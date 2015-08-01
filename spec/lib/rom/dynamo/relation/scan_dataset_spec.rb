# These tests run through the more advanced functionality of the DynamoDB API
# as described in the AWS Blog Post linked below.
#
# My idea is that ROM should provide a comfortable abstraction of the Dynamo API
# without being overly restrictive of the querying that can be performed. The
# obvious downside to this, is that some knowledge of how to query Dynamo is
# required
#
# @see http://goo.gl/hsWgtU
module ROM
  describe Dynamo::Relation::ScanDataset do

    include_context 'dynamo' do
      let(:table_name) { :basic_table }

      let(:table) { build(:basic_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:basic_table) do
            def with_filter_expression(expr)
              scan(filter_expression: expr)
            end

            def with_expression_values(hash)
              scan(expression_attribute_values: hash)
            end

            def with_projection(expr)
              scan(projection_expression: expr)
            end
          end

          commands(:basic_table) do
            define(:create) { result :one }
          end
        end
      }
    end

    context 'filter expressions (scan)' do
      # These tests are very brittle as they basically just rely on the default
      # structure of the :product factory. I'll modify these tests in the future
      # to be far more flexible. Right now, I just need a PoC to get past the
      # finishing line.

      let(:title) { Faker::Name.title }

      let(:launch_date) { { m: 12, d: 4, y: 1996 } }

      let(:item) { build(:product, title: title, launch_date: launch_date) }

      before { subject.command(:basic_table).create.call(item) }

      describe 'all products that dont have a launch month of November' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('launch_date.m <> :m')
            .with_expression_values(':m' => 11).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'all rover products that dont have a launch month of November' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('attribute_exists(features.rover) AND launch_date.m <> :m')
            .with_expression_values(':m' => 11).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'non-rovers' do
        specify { expect { subject.relation(:basic_table)
          .with_projection('title')
          .with_filter_expression('attribute_not_exists(features.rover)').one!
        }.to raise_error(ROM::TupleCountMismatchError) }
      end

      describe 'mid-range rovers or inexpensive products' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('(price BETWEEN :low AND :high) OR price < :very_low')
            .with_expression_values({
              ":very_low" => BigDecimal.new("1e8"),
              ":low" => BigDecimal.new("3e8"),
              ":high" => BigDecimal.new("5e8")
            }).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'within-item referencing: more orders placed than in stock' do
        specify { expect { subject.relation(:basic_table)
          .with_projection('title')
          .with_filter_expression('orders_placed > number_in_stock').one!
        }.to raise_error(ROM::TupleCountMismatchError) }
      end

      describe 'string prefixing' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('begins_with(title, :s)')
            .with_expression_values(":s" => title[0]).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'tags contain' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('contains(tags, :tag1) AND contains(tags, :tag2)')
            .with_expression_values({
              ":tag1" => "#Mars",
              ":tag2" => "#StillRoving",
            }).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'in operator' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('id in (:id1, :id2)')
            .with_expression_values({
              ":id1" => item[:id],
              ":id2" => rand(10000),
            }).one!
        }

        specify { expect(response["title"]).to eq title }
      end

      describe 'equivalently, with parentheses' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('(id = :id1) OR (id = :id2)')
            .with_expression_values({
              ":id1" => rand(10000),
              ":id2" => item[:id],
            }).one!
        }

        specify { expect(response["title"]).to eq title }
      end
    end
  end
end

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
      let(:title) { Faker::Name.title }

      let(:launch_date) { { m: 12, d: 4, y: 1996 } }

      let(:item) { build(:product, title: title, launch_date: launch_date) }

      before { subject.command(:basic_table).create.call(item) }

      describe '#with_filter_expression.#with_expression_values.#with_projection' do
        let(:response) {
          subject.relation(:basic_table)
            .with_projection('title')
            .with_filter_expression('LaunchDate.M <> :m')
            .with_expression_values(':m' => 11).one!
        }

        specify { expect(response["title"]).to eq title }
      end
    end
  end
end

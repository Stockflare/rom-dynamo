# These tests run through the more advanced functionality of the DynamoDB API
# as described in the AWS Blog Post linked below.
#
# My idea is that ROM should provide a comfortable abstraction of the Dynamo API
# without being overly restrictive of the querying that can be performed. The
# obvious downside to this, is that some knowledge of how to query Dynamo is
# required
#
# @see http://goo.gl/MVXbc7
module ROM
  describe Dynamo::Relation::Dataset do

    include_context 'dynamo' do
      let(:table_name) { :time_series_table }

      let(:table) { build(:time_series_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:time_series_table) do
            def by_id(id)
              retrieve(key: { id: id })
            end

            def between(after, before)

            end

            def after(after)

            end

            def before(before)

            end
          end

          commands(:time_series_table) do
            define(:create) { result :one }
          end
        end
      }
    end
    #
    # context 'projection expressions' do
    #   let(:id) { 205 }
    #
    #   let(:five_star_review) { "Do yourself a favor and buy this." }
    #
    #   let(:item) { build(:product, id: id, product_reviews: { five_star: [five_star_review] }) }
    #
    #   before { subject.command(:time_series_table).create.call(item) }
    #
    #   describe '#by_id' do
    #     let(:response) { subject.relation(:time_series_table).by_id(id).one! }
    #
    #     specify { expect(response["price"].to_i).to eq 500 }
    #
    #     specify { expect(response["product_reviews"]["five_star"]).to include five_star_review }
    #   end
    #
    #   describe '#by_price' do
    #     specify { expect { subject.relation(:time_series_table).by_price(item[:price]).one! }.to raise_error(Aws::DynamoDB::Errors::ValidationException) }
    #   end
    #
    #   describe '#by_id.#with_expression.#with_projection' do
    #     let(:response) {
    #       subject.relation(:time_series_table).by_id(id)
    #         .with_expression("#pr" => "product_reviews")
    #         .with_expression("#ri" => "related_items")
    #         .with_projection("price, color, #pr.five_star, #ri[0], #ri[2], #pr.no_star, #ri[4]").one!
    #     }
    #
    #     specify { expect(response["related_items"].count).to eq 2 }
    #
    #     specify { expect(response["gender"]).to be_nil }
    #   end
    # end
  end
end

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
  describe Dynamo::Relation::RetrievalDataset do

    include_context 'dynamo' do
      let(:table_name) { :basic_table }

      let(:table) { build(:basic_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:basic_table) do
            def by_id(id)
              retrieve(key: { id: id })
            end

            def with_expression(map)
              retrieve(expression_attribute_names: map)
            end

            def with_projection(expr)
              retrieve(projection_expression: expr)
            end
          end

          commands(:basic_table) do
            define(:create) { result :one }
          end
        end
      }
    end

    context 'projection expressions' do
      let(:id) { 205 }

      let(:five_star_review) { "Do yourself a favor and buy this." }

      let(:item) {
        {
          id: id,
          Title: "20-Bicycle 205",
          Description: "205 description",
          BicycleType: "Hybrid",
          Brand: "Brand-Company C",
          Price: 500,
          Gender: "B",
          Color: Set.new(["Red", "Black"]),
          ProductCategory: "Bike",
          InStock: true,
          QuantityOnHand: nil,
          NumberSold: BigDecimal.new("1E4"),
          RelatedItems: [
            341,
            472,
            649
          ],
          Pictures: { # JSON Map of views to url String
            FrontView: "http://example.com/products/205_front.jpg",
            RearView: "http://example.com/products/205_rear.jpg",
            SideView: "http://example.com/products/205_left_side.jpg",
          },
          ProductReviews: { # JSON Map of stars to List of review Strings
            FiveStar: [
              "Excellent! Can't recommend it highly enough!  Buy it!",
              five_star_review
            ],
            OneStar: [
              "Terrible product!  Do not buy this."
            ]
          }
        }
      }

      before { subject.command(:basic_table).create.call(item) }

      describe '#by_id' do
        let(:response) { subject.relation(:basic_table).by_id(id).one! }

        specify { expect(response["Price"].to_i).to eq 500 }

        specify { expect(response["ProductReviews"]["FiveStar"]).to include five_star_review }
      end

      describe '#by_id.#with_expression.#with_projection' do
        let(:response) {
          subject.relation(:basic_table).by_id(id)
            .with_expression("#pr" => "ProductReviews")
            .with_expression("#ri" => "RelatedItems")
            .with_projection("Price, Color, #pr.FiveStar, #ri[0], #ri[2], #pr.NoStar, #ri[4]").one!
        }

        specify { expect(response["RelatedItems"].count).to eq 2 }

        specify { expect(response["Gender"]).to be_nil }
      end
    end
  end
end

module ROM
  module Dynamo
    class Relation < ROM::Relation
      class RetrievalDataset < Dataset
        private

        def each_item(body, &block)
          block.call connection.get_item(body).data.item
        end
      end
    end
  end
end

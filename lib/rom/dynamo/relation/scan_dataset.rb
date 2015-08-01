module ROM
  module Dynamo
    class Relation < ROM::Relation
      class ScanDataset < Dataset
        private

        def each_item(body, &block)
          connection.scan(body).data.items.each(&block)
        end
      end
    end
  end
end

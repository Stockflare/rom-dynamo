module ROM
  module Dynamo
    class Relation < ROM::Relation
      class ScanDataset < Dataset
        def execute(body = chain)
          @response ||= connection.scan(merge_table_name(body)).data
        end

        private

        def each_item(body, &block)
          execute(body).items.each(&block)
        end
      end
    end
  end
end

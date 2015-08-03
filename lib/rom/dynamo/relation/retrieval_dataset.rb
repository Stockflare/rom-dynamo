module ROM
  module Dynamo
    class Relation < ROM::Relation
      class RetrievalDataset < Dataset
        def execute(body = chain)
          @response ||= connection.get_item(merge_table_name(body)).data
        end

        private

        def each_item(body, &block)
          block.call execute(body).item
        end
      end
    end
  end
end

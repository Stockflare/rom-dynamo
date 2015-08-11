module ROM
  module Dynamo
    class Relation < ROM::Relation
      class BatchGetDataset < Dataset
        def each(&block)
          each_item(@chain, &block)
        end

        def execute(body = chain)
          @response ||= connection.batch_get_item({
            request_items: { name => body }
          }).responses[name.to_s]
        end

        private

        def each_item(body, &block)
          execute(body).each(&block)
        end
      end
    end
  end
end

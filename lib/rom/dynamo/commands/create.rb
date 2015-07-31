module ROM
  module Dynamo
    module Commands
      # DynamoDB create command
      #
      # @api public
      class Create < ROM::Commands::Create
        adapter :dynamo
      end
    end
  end
end

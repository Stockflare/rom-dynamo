module ROM
  module Dynamo
    module Commands
      # DynamoDB delete command
      #
      # @api public
      class Delete < ROM::Commands::Delete
        adapter :dynamo
      end
    end
  end
end

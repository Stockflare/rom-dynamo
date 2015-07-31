module ROM
  module Dynamo
    module Commands
      # DynamoDB update command
      #
      # @api public
      class Update < ROM::Commands::Update
        adapter :dynamo
      end
    end
  end
end

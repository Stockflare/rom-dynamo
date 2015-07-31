module ROM
  module Dynamo
    module Commands
      # DynamoDB create command
      #
      # @api public
      class Create < ROM::Commands::Create
        adapter :dynamo

        def execute(tuple)
          attributes = input[tuple]
          validator.call(attributes)
          relation.insert(attributes.to_h)
          []
        end
      end
    end
  end
end

module ROM
  module Dynamo
    module Commands
      # DynamoDB delete command
      #
      # @api public
      class Delete < ROM::Commands::Delete
        adapter :dynamo

        def execute(tuple)
          attributes = input[tuple]
          validator.call(attributes)
          relation.delete(attributes.to_h)
          []
        end
      end
    end
  end
end

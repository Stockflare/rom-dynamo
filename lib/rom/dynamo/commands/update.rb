module ROM
  module Dynamo
    module Commands
      # DynamoDB update command
      #
      # @api public
      class Update < ROM::Commands::Update
        adapter :dynamo

        def execute(tuple)
          attributes = input[tuple]
          validator.call(attributes)
          if respond_to?(:key)
            keys = key(tuple)
            if keys.is_a?(Hash)
              attrs = attributes.to_h.delete_if { |k, _| keys.keys.include?(k) }
              relation.update(keys, attrs)
            else
              fail '#key must return type Hash'
            end
          else
            fail 'requires implementation of #key=>{}'
          end

          []
        end
      end
    end
  end
end

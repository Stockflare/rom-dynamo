module ROM
  module Dynamo
    module Plugins
      module TimeSeries
        def self.included(klass)
          klass.class_eval do
            def between(key, after, before)
              restrict(key_conditions: {
                key => {
                  comparison_operator: 'BETWEEN',
                  attribute_value_list: [after, before]
                }
              })
            end

            def after(key, after)
              restrict(key_conditions: {
                key => {
                  comparison_operator: 'GE',
                  attribute_value_list: [after]
                }
              })
            end

            def before(key, before)
              restrict(key_conditions: {
                key => {
                  comparison_operator: 'LE',
                  attribute_value_list: [before]
                }
              })
            end
          end
        end
      end
    end
  end
end

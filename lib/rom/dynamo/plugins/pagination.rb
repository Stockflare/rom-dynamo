module ROM
  module Dynamo
    module Plugins
      module Pagination
        class Pager
          include Options
          include Equalizer.new(:dataset, :options)

          option :last_key, reader: true, default: nil
          option :per_page, reader: true

          attr_reader :dataset

          def initialize(dataset, options = {})
            super
            @dataset = dataset
          end

          def at(dataset, last_key, per_page = self.per_page)
            self.class.new(
              dataset.start(last_key).limit(per_page),
              last_key: last_key, per_page: per_page
            )
          end

          def last_evaluated_key
            dataset.execute.last_evaluated_key
          end

          def next_page?
            !last_evaluated_key.nil?
          end

          alias_method :limit_value, :per_page
        end

        def self.included(klass)
          klass.class_eval do
            defines :per_page

            option :pager, reader: true, default: proc { |relation|
              Pager.new(relation.dataset, per_page: relation.class.per_page)
            }

            exposed_relations.merge([:pager, :per_page, :offset])
          end
        end

        def per_page(num)
          next_pager = pager.at(dataset, pager.last_key, num)
          __new__(next_pager.dataset, pager: next_pager)
        end

        def offset(last_key)
          next_pager = pager.at(dataset, last_key)
          __new__(next_pager.dataset, pager: next_pager)
        end
      end
    end
  end
end

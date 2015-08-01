module ROM
  module Dynamo
    class Relation < ROM::Relation
      class Dataset
        include Equalizer.new(:name, :connection)

        attr_reader :name, :connection, :chain

        def initialize(name, connection, chain = nil)
          @name, @connection = name, connection
          @chain = chain || {}
        end

        def restrict(query = nil)
          build(query) { |q| dup_as(Dataset, chain: q) }
        end

        def retrieve(query = nil)
          build(query) { |q| dup_as(RetrievalDataset, chain: q) }
        end

        def scan(query = nil)
          build(query) { |q| dup_as(ScanDataset, chain: q) }
        end

        def query(hash)
          connection.query merge_table_name(hash)
        end

        def insert(hash)
          connection.put_item merge_table_name(item: hash)
        end

        def delete(hash)
          connection.delete_item merge_table_name(hash)
        end

        def each(&block)
          each_item(merge_table_name(@chain), &block)
        end

        private

        def build(query)
          return self if query.nil?
          yield @chain.deep_merge(query)
        end

        def each_item(body, &block)
          connection.query(body).data.items.each(&block)
        end

        def merge_table_name(hash)
          hash.merge(table_name: name)
        end

        def dup_as(klass, opts = {})
          vars = [:@name, :@connection, :@chain]
          klass.allocate.tap do |out|
            vars.each { |k| out.instance_variable_set(k, instance_variable_get(k)) }
            opts.each { |k, v| out.instance_variable_set("@#{k}", v) }
          end
        end
      end
    end
  end
end

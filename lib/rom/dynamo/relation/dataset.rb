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

        def limit(num = nil)
          return self if num.nil?
          build({ limit: num }) { |q| dup_as(Dataset, chain: q) }
        end

        def start(key)
          return self if key.nil?
          build({ exclusive_start_key: key }) { |q| dup_as(Dataset, chain: q) }
        end

        def batch_get(query = nil)
          build(query) { |q| dup_as(BatchGetDataset, chain: q) }
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
          connection.delete_item merge_table_name(key: hash)
        end

        def update(key, hash, action = 'PUT')
          update = { attribute_updates: Hash[hash.map { |k,v| [k, { value: v, action: action }] }] }
          connection.update_item merge_table_name(update.merge(key: key))
        end

        def each(&block)
          each_item(merge_table_name(@chain), &block)
        end

        def execute(body = chain)
          @response ||= connection.query(merge_table_name(body)).data
        end

        private

        def build(query)
          return self if query.nil?
          yield @chain.deep_merge(query)
        end

        def each_item(body, &block)
          execute(body).items.each(&block)
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

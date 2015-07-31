module ROM
  module Dynamo
    class Relation < ROM::Relation
      class Dataset
        include Equalizer.new(:name, :connection)

        attr_reader :name, :connection, :conditions

        def initialize(name, connection, conditions = nil)
          @name, @connection = name, ddb
          @conditions = conditions || {}
        end

        def restrict(query = nil)
          return self if query.nil?
          conds = @conditions.merge(query)
          dup_as(Dataset, conditions: conds)
        end

        # def scan(hash)
        #   connection.scan merge_table_name(hash)
        # end

        def query(hash)
          connection.query merge_table_name(hash)
        end

        def insert(hash)
          connection.put_item merge_table_name(hash)
        end

        def delete(hash)
          connection.delete_item merge_table_name(hash)
        end

        def each(&block)
          each_item(merge_table_name(@conditions), &block)
        end

        private

        def each_items(body, &block)
          connection.query(body).data.each do |resp|
            puts "Response Item..."
            puts resp.inspect
            block.call(resp)
          end
        end

        def merge_table_name(hash)
          hash.merge(table_name: name)
        end

        def dup_as(klass, opts = {})
          vars = [:@name, :@connection, :@conditions]
          klass.allocate.tap do |out|
            vars.each { |k| out.instance_variable_set(k, instance_variable_get(k)) }
            opts.each { |k, v| out.instance_variable_set("@#{k}", v) }
          end
        end
      end
    end
  end
end

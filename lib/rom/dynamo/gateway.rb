require 'rom/repository'

module ROM
  module Dynamo
    class Gateway < ROM::Gateway
      def initialize(opts = {})
        raise "expected AWS Region" if opts[:region].nil?
        @connection = initialize_connection(opts)
        @datasets = {}
      end

      def dataset(name)
        @datasets[name] ||= Relation::Dataset.new(name, connection)
      end

      def dataset?(name)
        list = connection.list_tables
        list[:table_names].include?(name)
      end

      def [](name)
        @datasets[name]
      end

      private

      def initialize_connection(opts = {})
        Aws::DynamoDB::Client.new(region: opts[:region])
      end
    end
  end
end

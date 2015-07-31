require 'rom/repository'

module ROM
  module Dynamo
    class Repository < ROM::Gateway
      def initialize(opts = {})
        raise "expected Dynamo Table name" if opts[:table].nil?
        @connection = initialize_connection(opts)
        @datasets = {}
      end

      def dataset(name)
        @datasets[name] ||= Dataset.new(name, @connection)
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

      end
    end
  end
end

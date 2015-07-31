module ROM
  module Dynamo
    class Relation < ROM::Relation
      require 'rom/dynamo/relation/dataset'

      adapter :dynamo

      forward :restrict

      def insert(*args)
        dataset.insert(*args)
        self
      end

      def delete(*args)
        dataset.delete(*args)
        self
      end
    end
  end
end

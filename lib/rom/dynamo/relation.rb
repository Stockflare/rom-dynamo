module ROM
  module Dynamo
    class Relation < ROM::Relation
      require 'rom/dynamo/relation/dataset'
      require 'rom/dynamo/relation/retrieval_dataset'
      require 'rom/dynamo/relation/scan_dataset'

      adapter :dynamo

      forward :query, :scan, :retrieve

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

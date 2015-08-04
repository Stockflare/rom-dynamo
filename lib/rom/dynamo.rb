require 'rom'
require 'aws-sdk-core'
require 'active_support/core_ext/hash/deep_merge'

require 'rom/dynamo/version'
require 'rom/dynamo/relation'
require 'rom/dynamo/commands'
require 'rom/dynamo/gateway'
require 'rom/dynamo/plugin'

module ROM
  module Dynamo
    def self.stub!(client)
      @stubbed_client = client
      instance_eval do
        def stubbed_client
          @stubbed_client
        end
      end
      Gateway.class_eval do
        def initialize_connection(*a)
          ROM::Dynamo.stubbed_client
        end
      end
    end
  end
end

ROM.register_adapter(:dynamo, ROM::Dynamo)

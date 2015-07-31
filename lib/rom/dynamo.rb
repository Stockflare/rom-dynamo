require 'rom'
require 'aws-sdk-core'
require 'active_support/core_ext/hash/deep_merge'

require 'rom/dynamo/version'
require 'rom/dynamo/relation'
require 'rom/dynamo/commands'
require 'rom/dynamo/gateway'

ROM.register_adapter(:dynamo, ROM::Dynamo)

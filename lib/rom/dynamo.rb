require 'rom'
require 'aws-sdk-core'
require "rom/dynamo/version"
require 'rom/dynamo/relation'
require 'rom/dynamo/commands'
require 'rom/dynamo/repository'

ROM.register_adapter(:dynamo, Rom::Dynamo)

require 'rom/commands'

module ROM
  module Dynamo
    module Commands
      autoload :Create, 'rom/dynamo/commands/create'
      autoload :Update, 'rom/dynamo/commands/update'
      autoload :Delete, 'rom/dynamo/commands/delete'
    end
  end
end

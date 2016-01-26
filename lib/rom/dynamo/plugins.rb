require "rom/dynamo/plugins/pagination"
require "rom/dynamo/plugins/time_series"

ROM.plugins do
  adapter :dynamo do
    register :pagination, ROM::Dynamo::Plugins::Pagination, type: :relation
    register :time_series, ROM::Dynamo::Plugins::TimeSeries, type: :relation
  end
end

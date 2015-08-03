require "rom/dynamo/plugin/pagination"
require "rom/dynamo/plugin/time_series"

ROM.plugins do
  adapter :dynamo do
    register :pagination, ROM::Dynamo::Plugin::Pagination, type: :relation
    register :time_series, ROM::Dynamo::Plugin::TimeSeries, type: :relation
  end
end

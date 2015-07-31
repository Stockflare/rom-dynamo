module Helpers
  def dynamo
    Aws::DynamoDB::Client.new(endpoint: ENV['DYNAMO_ENDPOINT'])
  end

  def create_table_and_wait(table, &block)
    dynamo.create_table(table)
    dynamo.wait_until(:table_exists, table_name: table[:table_name])
    block.call
    dynamo.delete_table(table_name: table[:table_name])
  end
end

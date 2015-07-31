shared_context 'dynamo' do
  let(:table_name) { raise_on_missing_definition(:table_name) }

  let(:table) { raise_on_missing_definition(:table) }

  around { |ex| create_table_and_wait(table, &ex) }

  def dynamo
    Aws::DynamoDB::Client.new(endpoint: ENV['DYNAMO_ENDPOINT'])
  end

  def create_table_and_wait(table, &block)
    dynamo.create_table(table)
    dynamo.wait_until(:table_exists, table_name: table_name)
    block.call
    dynamo.delete_table(table_name: table_name)
  end

  def raise_on_missing_definition(key)
    raise "let(:#{key}) definition required to use dynamo context"
  end
end

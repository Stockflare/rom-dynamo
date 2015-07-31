module ROM
  describe Dynamo::Relation do

    let(:table_name) { "example_table_name" }

    let(:table) {
      {
        :table_name => table_name,
        :attribute_definitions => [{
          :attribute_name => :Id,
          :attribute_type => :N
        }],
        :key_schema => [{
          :attribute_name => :Id,
          :key_type => :HASH
        }],
        :provisioned_throughput => {
          :read_capacity_units => 1,
          :write_capacity_units => 1,
        }
      }
    }

    around { |b| create_table_and_wait(table, &b) }

    it { true }
  end
end

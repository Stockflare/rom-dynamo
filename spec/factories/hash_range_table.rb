FactoryGirl.define do
  factory :hash_range_table, class: Hash do
    table_name { Faker::Internet.domain_word }

    attribute_definitions do
      [{
        attribute_name: :id,
        attribute_type: :S
      }, {
        attribute_name: :date,
        attribute_type: :S
      }]
    end

    key_schema do
      [{
        attribute_name: :id,
        key_type: :HASH
      }, {
        attribute_name: :date,
        key_type: :RANGE
      }]
    end

    global_secondary_indexes do
      [
        {
          index_name: 'by_id',
          key_schema: [
            {
              attribute_name: :id,
              key_type: :HASH
            }
          ],
          projection: {
            projection_type: "ALL"
          },
          provisioned_throughput: {
            read_capacity_units: 1,
            write_capacity_units: 1
          }
        }
      ]
    end

    provisioned_throughput do
      {
        :read_capacity_units => 1,
        :write_capacity_units => 1,
      }
    end

    initialize_with { attributes }
  end
end

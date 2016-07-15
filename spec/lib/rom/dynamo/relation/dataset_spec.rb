# These tests run through the more advanced functionality of the DynamoDB API
# as described in the AWS Blog Post linked below.
#
# My idea is that ROM should provide a comfortable abstraction of the Dynamo API
# without being overly restrictive of the querying that can be performed. The
# obvious downside to this, is that some knowledge of how to query Dynamo is
# required
#
# @see http://goo.gl/MVXbc7
module ROM
  describe Dynamo::Relation::Dataset do

    include_context 'dynamo' do
      let(:table_name) { :hash_range_table }

      let(:table) { build(:hash_range_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:hash_range_table) do
            use :pagination
            use :time_series

            def by_id(id)
              restrict(key_conditions: {
                id: {
                  comparison_operator: 'EQ',
                  attribute_value_list: [id]
                }
              })
            end
          end

          commands(:hash_range_table) do
            define(:create) { result :one }
            define(:delete) { }
            define(:update) do
              def key(attributes)
                { id: attributes[:id], date: attributes[:date] }
              end
            end
          end


        end
      }
    end

    context 'range (time-series) expressions' do
      # eg: 2015-08-01
      let(:id) { DateTime.now.strftime('%Y-%m-%d') }

      let(:num_of_items) { 10 }

      let(:time_step) { 60 }

      before do
        items = (0...num_of_items).to_a.map do |i|
          date = (DateTime.now + time_step * (i + 1)).iso8601
          build(:hash_range, id: id, date: date)
        end
        items.each { |item| subject.command(:hash_range_table).create.call item }
      end

      describe 'delete record' do
        let(:after) { (DateTime.now + time_step).iso8601 }

        let(:key) { { id: id, date: after } }

        before { subject.command(:hash_range_table).delete.call(key) }

        specify { expect(subject.relation(:hash_range_table).by_id(id).after(:date, after).to_a.size).to eq num_of_items - 1 }
      end

      describe 'update record' do
        let(:after) { (DateTime.now + time_step).iso8601 }

        let(:data) { { foo: 'bar', bar: 'foo' } }

        let(:key) { { id: id, date: after } }

        before { subject.command(:hash_range_table).update.call(key.merge(data)) }

        specify { expect(subject.relation(:hash_range_table).by_id(id).after(:date, after).to_a.first['foo']).to eq 'bar' }
      end

      describe 'between all' do
        let(:after) { DateTime.now.iso8601 }
        let(:before) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).between(:date, after, before).to_a }

        specify { expect(response.size).to eq num_of_items }
      end

      describe 'between some time steps' do
        let(:jump) { 2 }
        let(:after) { (DateTime.now + (time_step * jump) + 1).iso8601 }
        let(:before) { (DateTime.now + (time_step * (num_of_items - jump)) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).between(:date, after, before).to_a }

        specify { expect(response.size).to eq num_of_items - jump * 2 }
      end

      describe 'before last time step plus one second' do
        let(:future) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).before(:date, future).to_a }

        specify { expect(response.size).to eq num_of_items }
      end

      describe 'before last time step minus two time steps' do
        let(:future) { (DateTime.now + (time_step * (num_of_items - 2)) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).before(:date, future).to_a }

        specify { expect(response.size).to eq num_of_items - 2 }
      end

      describe 'before all' do
        let(:now) { DateTime.now.iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).before(:date, now).to_a }

        specify { expect(response).to be_empty }
      end

      describe 'single result (limit:1) after now' do
        let(:now) { DateTime.now.iso8601 }
        let(:response) {
          subject.relation(:hash_range_table)
            .by_id(id)
            .after(:date, now)
            .per_page(1)
        }

        describe 'first page' do
          specify { expect(response.to_a.size).to eq 1 }

          specify { expect(response.pager.last_evaluated_key).to be_a Hash }

          specify { expect(response.pager.last_evaluated_key.keys).to include "id", "date" }

          specify { expect(response.one!["id"]).to eq response.pager.last_evaluated_key["id"] }

          specify { expect(response.one!["date"]).to eq response.pager.last_evaluated_key["date"] }
        end

        describe 'second page' do
          let(:last_evaluated_key) { response.pager.last_evaluated_key }
          let(:second_page) {
            subject.relation(:hash_range_table)
              .by_id(id)
              .after(:date, now)
              .per_page(1)
              .offset(last_evaluated_key)
          }

          specify { expect(second_page.to_a.size).to eq 1 }

          specify { expect(second_page.pager.last_evaluated_key).to be_a Hash }

          specify { expect(second_page.pager.last_evaluated_key.keys).to include "id", "date" }

          specify { expect(second_page.one!["id"]).to eq second_page.pager.last_evaluated_key["id"] }

          specify { expect(second_page.one!["date"]).to eq second_page.pager.last_evaluated_key["date"] }

          specify { expect(second_page.pager.last_evaluated_key["date"]).to_not eq last_evaluated_key["date"] }
        end
      end

      describe 'after now' do
        let(:now) { DateTime.now.iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).after(:date, now) }

        specify { expect(response.to_a.size).to eq num_of_items }
      end

      describe 'after two time steps' do
        # Current time plus two time steps and an additional second
        let(:now) { (DateTime.now + (time_step * 2) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).after(:date, now) }

        specify { expect(response.to_a.size).to eq num_of_items - 2 }
      end

      describe 'after all' do
        # Current time plus two time steps and an additional second
        let(:now) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:hash_range_table).by_id(id).after(:date, now) }

        specify { expect(response.to_a).to be_empty }
      end
    end
  end
end

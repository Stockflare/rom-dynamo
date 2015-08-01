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
      let(:table_name) { :time_series_table }

      let(:table) { build(:time_series_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:time_series_table) do
            def by_id(id)
              restrict(key_conditions: {
                id: {
                  comparison_operator: 'EQ',
                  attribute_value_list: [id]
                }
              })
            end

            def between(after, before)
              restrict(key_conditions: {
                date: {
                  comparison_operator: 'BETWEEN',
                  attribute_value_list: [after, before]
                }
              })
            end

            def after(after)
              restrict(key_conditions: {
                date: {
                  comparison_operator: 'GE',
                  attribute_value_list: [after]
                }
              })
            end

            def before(before)
              restrict(key_conditions: {
                date: {
                  comparison_operator: 'LE',
                  attribute_value_list: [before]
                }
              })
            end
          end

          commands(:time_series_table) do
            define(:create) { result :one }
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
          build(:time_series, id: id, date: date)
        end
        items.each { |item| subject.command(:time_series_table).create.call item }
      end

      describe 'between all' do
        let(:after) { DateTime.now.iso8601 }
        let(:before) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).between(after, before).to_a }

        specify { expect(response.size).to eq num_of_items }
      end

      describe 'between some time steps' do
        let(:jump) { 2 }
        let(:after) { (DateTime.now + (time_step * jump) + 1).iso8601 }
        let(:before) { (DateTime.now + (time_step * (num_of_items - jump)) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).between(after, before).to_a }

        specify { expect(response.size).to eq num_of_items - jump * 2 }
      end

      describe 'before last time step plus one second' do
        let(:future) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).before(future).to_a }

        specify { expect(response.size).to eq num_of_items }
      end

      describe 'before last time step minus two time steps' do
        let(:future) { (DateTime.now + (time_step * (num_of_items - 2)) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).before(future).to_a }

        specify { expect(response.size).to eq num_of_items - 2 }
      end

      describe 'before all' do
        let(:now) { DateTime.now.iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).before(now).to_a }

        specify { expect(response).to be_empty }
      end

      describe 'after now' do
        let(:now) { DateTime.now.iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).after(now).to_a }

        specify { expect(response.size).to eq num_of_items }
      end

      describe 'after two time steps' do
        # Current time plus two time steps and an additional second
        let(:now) { (DateTime.now + (time_step * 2) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).after(now).to_a }

        specify { expect(response.size).to eq num_of_items - 2 }
      end

      describe 'after all' do
        # Current time plus two time steps and an additional second
        let(:now) { (DateTime.now + (time_step * num_of_items) + 1).iso8601 }
        let(:response) { subject.relation(:time_series_table).by_id(id).after(now).to_a }

        specify { expect(response).to be_empty }
      end
    end
  end
end

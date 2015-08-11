module ROM
  describe Dynamo::Relation::BatchGetDataset do

    include_context 'dynamo' do
      let(:table_name) { :hash_table }

      let(:table) { build(:hash_table, table_name: table_name) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:hash_table) do
            def by_ids(ids)
              batch_get(keys: ids.map { |id| { id: id } })
            end
          end

          commands(:hash_table) do
            define(:create) { result :one }
          end
        end
      }
    end

    context 'batch get item requests' do
      let(:num_of_items) { 10 }

      let(:time_step) { 60*60*24 }

      let(:items) {
        (0...num_of_items).to_a.map do |i|
          time = Time.now + time_step * (i + 1)
          build(:hash, id: time.to_i, date: time.iso8601)
        end
      }

      before { items.each { |item| subject.command(:hash_table).create.call item } }

      describe 'response' do
        let(:response_size) { rand(1..num_of_items) }

        let(:ids) { items.sample(response_size).map { |item| item[:id] } }

        let(:response) { subject.relation(:hash_table).by_ids(ids).to_a }

        specify { expect(response.size).to eq response_size }

        specify { expect(response.map { |r| r["id"] }).to include *ids }
      end
    end
  end
end

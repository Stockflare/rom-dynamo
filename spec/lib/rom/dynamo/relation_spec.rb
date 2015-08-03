module ROM
  describe Dynamo::Relation do

    include_context 'dynamo' do
      let(:table_name) { :hash_table }

      let(:table) { build(:hash_table, table_name: table_name.to_s) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:hash_table) { }
          commands(:hash_table) do
            define(:create) { result :one }
            define(:update) { result :one }
            define(:delete) { result :one }
          end
        end
      }
    end

    context 'creation' do
      let(:hash) { build(:hash) }

      specify { expect { subject.command(:hash_table).create.call(hash) }.to_not raise_error }
    end

  end
end

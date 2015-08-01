module ROM
  describe Dynamo::Relation do

    include_context 'dynamo' do
      let(:table_name) { :basic_table }

      let(:table) { build(:basic_table, table_name: table_name.to_s) }
    end

    include_context 'rom setup' do
      let(:definitions) {
        Proc.new do
          relation(:basic_table) { }
          commands(:basic_table) do
            define(:create) { result :one }
            define(:update) { result :one }
            define(:delete) { result :one }
          end
        end
      }
    end

    context 'creation' do
      let(:basic) { build(:basic) }

      specify { expect { subject.command(:basic_table).create.call(basic) }.to_not raise_error }
    end

  end
end

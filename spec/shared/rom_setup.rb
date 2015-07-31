shared_context 'rom setup' do
  let(:definitions) { nil }

  let(:setup) { ROM.setup(:dynamo, region: 'us-east-1', &definitions) }

  subject(:rom) { setup }
end

describe Snippets::Validate do
  describe '#call' do
    subject { described_class.new.call(input) }

    let(:snippet) { build(:snippet) }

    context 'when params are invalid' do
      let(:input) { { params: {} } }

      it { is_expected.to be_failure }

      it 'returns errors' do
        expect(subject.failure).to match(errors: be_an(Array).and(be_any))
      end
    end

    context 'when params are valid' do
      let(:output) { { params: { body: snippet.body, language: snippet.language } } }
      let(:input) { output.deep_merge(external_extra_key: 'foo', params: { internal_extra_key: 'bar' }) }

      it { is_expected.to be_success }

      it 'returns filtered validated params' do
        expect(subject.value!).to eq(output)
      end
    end
  end
end

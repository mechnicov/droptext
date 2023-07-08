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

    context 'when params are invalid' do
      let(:input) { { params: { body: snippet.body, language: snippet.language } } }

      it { is_expected.to be_success }

      it 'returns errors' do
        expect(subject.value!).to eq(input)
      end
    end
  end
end

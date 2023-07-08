describe Snippets::Persist do
  describe '#call' do
    subject { described_class.new.call(input) }

    let(:snippet) { build(:snippet) }
    let(:input) { { params: { body: snippet.body, language: snippet.language } } }
    let(:new_token) { 'AsDFXxq9' }

    context 'when snippet with generated token exists in the database' do
      let(:existing_snippet) { create(:snippet) }

      before { allow(SecureRandom).to receive(:alphanumeric).and_return(existing_snippet.token, new_token) }

      it { is_expected.to be_success }

      it 'inserts new record' do
        expect { subject }.to change(Snippet, :count).from(1).to(2)
      end

      it 'returns token' do
        expect(subject.value!).to eq(token: new_token)
      end
    end

    context 'when snippet with generated token does not exist in the database' do
      before { allow(SecureRandom).to receive(:alphanumeric).and_return(new_token) }

      it { is_expected.to be_success }

      it 'inserts new record' do
        expect { subject }.to change(Snippet, :count).from(0).to(1)
      end

      it 'returns token' do
        expect(subject.value!).to eq(token: new_token)
      end
    end
  end
end

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

      it 'creates new snippet' do
        expect { subject }.to change(Snippet, :count).from(1).to(2)
      end

      it 'returns token' do
        expect(subject.value!).to eq(token: new_token)
      end
    end

    context 'when snippet with generated token does not exist in the database' do
      it { is_expected.to be_success }

      it 'creates new snippet' do
        expect { subject }.to change(Snippet, :count).from(0).to(1)
      end

      it 'returns created snippet token' do
        expect(subject.value!).to eq(token: Snippet.last.token)
      end

      it 'generates token with specific format' do
        expect(subject.value![:token]).to match(/\A[a-z\d]{#{Settings::SNIPPET_TOKEN_LENGHT}}\z/i)
      end
    end
  end
end

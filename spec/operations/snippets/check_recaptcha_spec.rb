describe Snippets::CheckRecaptcha do
  describe '#call' do
    subject { described_class.new.call(input) }

    let(:input) { { params: { recaptcha_token: 'asdf', key: :value } } }

    before { allow(HTTParty).to receive(:get).and_return(double(body: response.to_json)) }

    context 'when response is not success' do
      let(:response) { { success: false, score: 1.0, action: 'callback' } }

      it { is_expected.to be_failure }

      it 'returns error' do
        expect(subject.failure).to eq(errors: [I18n.t('recaptcha.error')])
      end
    end

    context 'when score is low' do
      let(:response) { { success: true, score: 0.0, action: 'callback' } }

      it { is_expected.to be_failure }

      it 'returns error' do
        expect(subject.failure).to eq(errors: [I18n.t('recaptcha.error')])
      end
    end

    context 'when action is wrong' do
      let(:response) { { success: true, score: 1.0, action: 'wtf' } }

      it { is_expected.to be_failure }

      it 'returns error' do
        expect(subject.failure).to eq(errors: [I18n.t('recaptcha.error')])
      end
    end

    context 'when response is successful, score is enough and action is valid' do
      let(:response) { { success: true, score: 1.0, action: 'callback' } }

      it { is_expected.to be_success }

      it 'returns value without recaptcha_token key' do
        expect(subject.value!).to eq(params: { key: :value })
      end
    end
  end
end

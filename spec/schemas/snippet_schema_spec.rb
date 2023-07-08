describe SnippetSchema do
  describe '.rules' do
    it 'validates body and language' do
      expect(described_class.rules).to match(body: be_an(Object), language: be_an(Object))
    end
  end

  describe '.call' do
    subject { described_class.call(params) }

    let(:snippet) { build(:snippet) }

    context 'when body is absent' do
      let(:params) { { language: snippet.language } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(body: [I18n.t('dry_schema.errors.snippet.rules.body.key?')])
      end
    end

    context 'when body is nil' do
      let(:params) { { body: nil, language: snippet.language } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(body: [I18n.t('dry_schema.errors.snippet.rules.body.filled?')])
      end
    end

    context 'when body is empty string' do
      let(:params) { { body: '', language: snippet.language } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(body: [I18n.t('dry_schema.errors.snippet.rules.body.filled?')])
      end
    end

    context 'when language is absent' do
      let(:params) { { body: snippet.body } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(language: [I18n.t('dry_schema.errors.snippet.rules.language.key?')])
      end
    end

    context 'when language is nil' do
      let(:params) { { body: snippet.body, language: nil } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(language: [I18n.t('dry_schema.errors.snippet.rules.language.filled?')])
      end
    end

    context 'when language is empty string' do
      let(:params) { { body: snippet.body, language: '' } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(language: [I18n.t('dry_schema.errors.snippet.rules.language.filled?')])
      end
    end

    context 'when language is invalid' do
      let(:params) { { body: snippet.body, language: 'qwertyuiop' } }

      it { is_expected.to be_failure }

      it 'returns error message' do
        expect(subject.errors.to_h).to eq(language: [I18n.t('dry_schema.errors.snippet.rules.language.included_in?')])
      end
    end

    context 'when params are valid' do
      let(:params) { { body: snippet.body, language: snippet.language } }

      it { is_expected.to be_success }

      it 'does not return any error message' do
        expect(subject.errors.to_h).to eq({})
      end
    end
  end
end

describe Snippets::Create do
  describe '.call' do
    subject { described_class.call(input) }

    let(:snippet) { build(:snippet) }
    let(:input) { { params: { body: snippet.body, language: snippet.language } } }

    context 'when recaptcha failed' do
      let(:errors) { { errors: ['recaptcha error'] } }

      before do
        Droptext::Container.stub('snippets.check_recaptcha', proc { Failure(errors) })
      end

      it { is_expected.to be_failure }

      it 'returns error' do
        expect(subject.failure).to eq(errors)
      end
    end

    context 'when validation failed' do
      let(:errors) { { errors: ['validation error'] } }

      before do
        Droptext::Container.stub('snippets.check_recaptcha', proc { Success(input) })
        Droptext::Container.stub('snippets.validate', proc { Failure(errors) })
      end

      it { is_expected.to be_failure }

      it 'returns error' do
        expect(subject.failure).to eq(errors)
      end
    end

    context 'when all checks successful' do
      before do
        Droptext::Container.stub('snippets.check_recaptcha', proc { Success(input) })
        Droptext::Container.stub('snippets.validate', proc { Success(input) })
      end

      it { is_expected.to be_success }

      it 'creates new snippet' do
        expect { subject }.to change(Snippet, :count).from(0).to(1)
      end

      it 'returns token' do
        expect(subject.value!).to eq(token: Snippet.last.token)
      end
    end
  end
end

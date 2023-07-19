describe SnippetsController, type: :request do
  describe 'POST /s' do
    subject { post '/s' }

    context 'when recaptcha failed' do
      let(:recaptcha_errors) { { errors: ['recaptcha error'] } }

      before do
        Droptext::Container.stub(
          'snippets.create',
          Snippets::Create.new(
            check_recaptcha: proc { Failure(recaptcha_errors) },
          )
        )
      end

      it 'responses with recaptcha errors JSON' do
        subject

        expect(response.body).to eq(recaptcha_errors.to_json)
      end
    end

    context 'when validation failed' do
      let(:validation_errors) { { errors: ['validation error'] } }

      before do
        Droptext::Container.stub(
          'snippets.create',
          Snippets::Create.new(
            check_recaptcha: proc { Success() },
            validate: proc { Failure(validation_errors) },
          )
        )
      end

      it 'responses with validation errors JSON' do
        subject

        expect(response.body).to eq(validation_errors.to_json)
      end
    end

    context 'when succeed' do
      let(:success) { { result: true } }

      before do
        Droptext::Container.stub(
          'snippets.create',
          Snippets::Create.new(
            check_recaptcha: proc { Success() },
            validate: proc { Success() },
            persist: proc { Success(success) },
          )
        )
      end

      it 'responses with success result JSON' do
        subject

        expect(response.body).to eq(success.to_json)
      end
    end
  end

  describe 'GET /' do
    subject { get '/' }

    before { subject }

    it 'renders new template' do
      expect(response).to render_template(:new)
    end

    it 'assigns blank snippet instance variable' do
      expect(assigns(:snippet)).to be_a(Snippet).and(have_attributes(Snippet.new.attributes))
    end
  end

  describe 'GET /s/:token' do
    subject { get "/s/#{token}" }

    context 'when there is no such snippet' do
      let!(:token) { 'absent' }

      it 'raises not found error' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'when there is no such snippet' do
      let!(:token) { 'present' }
      let!(:snippet) { create(:snippet, token:) }

      before { subject }

      it 'renders show template' do
        expect(response).to render_template(:show)
      end

      it 'assigns snippet instance variable found by token' do
        expect(assigns(:snippet)).to eq snippet
      end
    end
  end
end

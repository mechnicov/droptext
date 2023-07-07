module Snippets
  class CheckRecaptcha < BaseOperation
    def call(input)
      secret = Settings::RECAPTCHA_SECRET_KEY
      response = CGI.escape(input[:params].delete(:recaptcha_token).to_s)

      recaptcha_url = URI.parse(Settings::BASE_RECAPTCHA_URL)
      recaptcha_url.query = { secret:, response: }.to_query

      recaptcha_response = HTTParty.get(recaptcha_url)
      json = JSON.parse(recaptcha_response.body, symbolize_names: true)

      return Success(input) if json[:success] && json[:score] >= Settings::MINIMUM_RECAPTCHA_SCORE && json[:action] == 'callback'

      Failure(errors: [I18n.t('recaptcha.error')])
    end
  end
end

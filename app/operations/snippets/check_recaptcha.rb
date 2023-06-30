module Snippets
  class CheckRecaptcha
    include Dry::Transaction::Operation

    MINIMUM_RECAPTCHA_SCORE = 0.75
    BASE_RECAPTCHA_URL = 'https://www.google.com/recaptcha/api/siteverify'.freeze

    def call(input)
      secret_key = ENV['RECAPTCHA_SECRET_KEY']
      token = CGI.escape(input[:params].delete(:recaptcha_token).to_s)

      recaptcha_url = URI.parse(BASE_RECAPTCHA_URL)
      recaptcha_url.query = { secret: secret_key, response: token }.to_query

      response = HTTParty.get(recaptcha_url)
      json = JSON.parse(response.body, symbolize_names: true)

      return Success(input) if json[:success] && json[:score] >= MINIMUM_RECAPTCHA_SCORE && json[:action] == 'callback'

      Failure(errors: [I18n.t('recaptcha.error')])
    end
  end
end

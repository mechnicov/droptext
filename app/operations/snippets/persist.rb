module Snippets
  class Persist < BaseOperation
    def call(input)
      token = Snippet.create!(token: generate_token, **input[:params]).token

      Success(token:)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    private

    def generate_token
      SecureRandom.alphanumeric(Settings::SNIPPET_TOKEN_LENGHT)
    end
  end
end

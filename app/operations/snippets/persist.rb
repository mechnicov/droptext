module Snippets
  class Persist
    include Dry::Transaction::Operation

    def call(input)
      token = Snippet.create!(token: generate_token, **input[:params]).token

      Success(token: token)
    rescue ActiveRecord::RecordNotUnique
      retry
    end

    private

    def generate_token
      SecureRandom.alphanumeric(Snippet::TOKEN_LENGHT)
    end
  end
end

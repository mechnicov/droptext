FactoryBot.define do
  factory :snippet do
    token { SecureRandom.alphanumeric(Settings::SNIPPET_TOKEN_LENGHT) }
    language { Settings::SNIPPET_LANGUAGES.sample }
    body { "puts 'Hello world!'"}
  end
end

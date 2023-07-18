module Snippets
  class CreateContract < BaseContract
    config.messages.namespace = :snippet

    schema do
      required(:body).filled
      required(:language).filled(included_in?: Settings::SNIPPET_LANGUAGES)
    end
  end
end

class Snippet < ApplicationRecord
  enum language: Settings::SNIPPET_LANGUAGES.index_with(&:itself), _suffix: true
end

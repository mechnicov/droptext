class Snippet < ApplicationRecord
  enum language: Settings::SNIPPET_LANGUAGES.each_with_object({}) { |language, enum_hash| enum_hash[language] = language }, _suffix: true
end

settings = YAML.load_file(Rails.root.join('config', 'settings.yml')).with_indifferent_access
h = ActionController::Base.helpers

Settings = Module.new

Settings::OG_META_TAGS = settings[:og_meta_tags].freeze
Settings::OG_META_TAGS_HTML = h.safe_join(Settings::OG_META_TAGS.map { |property, content| h.tag.meta(property: "og:#{property}", content: content) }).freeze

Settings::SNIPPET_TOKEN_LENGHT = settings[:snippet][:token_length]
Settings::SNIPPET_LANGUAGES = settings[:snippet][:languages].freeze
Settings::SNIPPET_UNSAFE_WORDS = settings[:snippet][:unsafe_words].freeze

Settings::BASE_RECAPTCHA_URL = settings[:recaptcha][:base_recaptcha_url].freeze
Settings::MINIMUM_RECAPTCHA_SCORE = settings[:recaptcha][:minimum_score]
Settings::RECAPTCHA_SITE_KEY = ENV['RECAPTCHA_SITE_KEY'].freeze
Settings::RECAPTCHA_SECRET_KEY = ENV['RECAPTCHA_SECRET_KEY'].freeze

Settings.constants.each do |constant|
  Settings.define_singleton_method(constant.downcase) { Settings.const_get(constant) }
end

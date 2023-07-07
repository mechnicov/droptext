require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Droptext
  class Application < Rails::Application
    config.load_defaults 7.0
    config.time_zone = 'Moscow'
    config.i18n.default_locale = :ru
    config.action_mailer.default_url_options = credentials.config[:base_url]
    self.default_url_options = config.action_mailer.default_url_options
  end
end

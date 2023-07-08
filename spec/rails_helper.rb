require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort 'The Rails environment is running in production mode!' if Rails.env.production?
require 'rspec/rails'

require 'dry/container/stub'
require 'dry/monads'

require 'support/database_cleaner'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

Droptext::Container.enable_stubs!

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
  end

  config.include FactoryBot::Syntax::Methods
  config.include Dry::Monads[:result]
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

require 'rails_helper'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  config.include FeaturesHelper, type: :feature

  config.use_transactional_fixtures = false

  # SETUP DATABASE CLEANER
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end

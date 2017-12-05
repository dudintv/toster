require 'rails_helper'
require 'capybara/email/rspec'

require 'capybara/poltergeist'
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 2
Capybara.server = :puma

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

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'support/shoulda_matchers'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'billy/capybara/rspec'
require 'support/billy_config'
require 'support/billy_driver'

Capybara.javascript_driver = :selenium_billy

Rails.application.load_tasks

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

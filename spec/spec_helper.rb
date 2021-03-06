require 'simplecov'
SimpleCov.start

require 'factory_girl_rails'
require 'support/database_cleaner'
require 'fantaskspec'
require 'support/fixture_routes'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include FactoryGirl::Syntax::Methods

  config.infer_rake_task_specs_from_file_location!

  # silence STDOUT
  config.before { allow($stdout).to receive(:puts) }

end

FIXTURES_ROOT="#{Rails.root}/spec/fixtures"


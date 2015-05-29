# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
require "spec_helper"
require "rspec/rails"

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../../db/migrate", __FILE__)

Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
end

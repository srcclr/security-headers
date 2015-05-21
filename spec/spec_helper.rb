require File.expand_path("../../spec/dummy/config/environment.rb",  __FILE__)
require_relative '../lib/headlines'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "headlines/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "headlines"
  s.version     = Headlines::VERSION
  s.authors     = ["Securonauts"]
  s.email       = ["support@securonauts.com"]
  s.homepage    = "https://www.securonauts.com"
  s.summary     = "Security vulnerabilities scanner"
  s.description = "Security vulnerabilities scanner"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "interactor-rails", ">= 2.0"
  s.add_dependency "iso_country_codes", "~> 0.7.1"
  s.add_dependency "faraday", "~> 0.9.1"
  s.add_dependency "faraday_middleware", "~> 0.9.0"
  s.add_dependency "rubyzip", ">= 1.0.0"
  s.add_dependency "rails", "= 4.1.13"
  s.add_dependency "upsert", ">= 2.1"
  s.add_dependency "nokogiri", ">= 1.5"
  s.add_dependency "ethon", "0.8.0"
  s.add_dependency "typhoeus", "0.8.0"

  s.add_development_dependency "active_model_serializers", ">= 0.9"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "byebug"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "pg"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "sidekiq"
  s.add_development_dependency "webmock"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "ffaker"
end

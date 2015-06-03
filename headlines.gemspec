$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "headlines/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "headlines"
  s.version     = Headlines::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Headlines."
  s.description = "TODO: Description of Headlines."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "interactor-rails", ">= 2.0"
  s.add_dependency "faraday", "~> 0.9.1"
  s.add_dependency "faraday_middleware", "~> 0.9.0"
  s.add_dependency "rubyzip", ">= 1.0.0"
  s.add_dependency "rails", "~> 4.2.1"
  s.add_dependency "upsert", ">= 2.1"
  s.add_dependency "nokogiri", ">= 1.5"

  s.add_development_dependency "byebug"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "webmock"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "pg"
  s.add_development_dependency "rubocop"
  s.add_development_dependency "rspec-its"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sidekiq"
  s.add_development_dependency "byebug"
  s.add_development_dependency "factory_girl_rails"
end

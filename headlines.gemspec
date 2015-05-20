$:.push File.expand_path("../lib", __FILE__)

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
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end

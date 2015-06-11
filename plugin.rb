# name: headlines
# about: Security vulnerabilities scanner
# version: 0.0.1
# author: Securonauts

gem("interactor", "3.1.0")
gem("interactor-rails", "2.0.1", require_name: "interactor/rails")
gem("faraday_middleware", "0.9.1")
gem("rubyzip", "1.1.7", require_name: "zip")
gem("upsert", "2.1.0")
gem("responders", "2.1.0")

gem("its-it", "1.1.1")
gem("key_struct", "0.4.2")
gem("modware", "0.1.2")
gem("schema_monkey", "2.1.0")
gem("schema_plus_core", "0.5.0", require_name: "schema_plus/core")
gem("schema_plus_views", "0.2.0", require_name: "schema_plus/views")

require(File.expand_path("../lib/headlines", __FILE__))

Discourse::Application.routes.append do
  mount Headlines::Engine, at: "/headlines"
end

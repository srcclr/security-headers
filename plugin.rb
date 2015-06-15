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

register_asset('stylesheets/components/switch.css.scss')
register_asset('stylesheets/components/charts.css.scss')
register_asset('stylesheets/components/breadcrumb.css.scss')

register_asset('stylesheets/views/headlines.css.scss')

register_asset('javascripts/discourse/controllers/headlines.js.es6')

register_asset('javascripts/discourse/templates/headlines-charts.hbs')
register_asset('javascripts/discourse/templates/headlines-sites-list.hbs')
register_asset('javascripts/discourse/templates/headlines-site.hbs')

register_asset('javascripts/discourse/routes/headlines.js.es6')

Discourse::Application.routes.append do
  mount Headlines::Engine, at: "/headlines"
end

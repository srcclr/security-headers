# name: headlines
# about: Security vulnerabilities scanner
# version: 0.0.1
# author: SourceClear

gem("interactor", "3.1.0")
gem("interactor-rails", "2.0.1", require_name: "interactor/rails")
gem("iso_country_codes", "0.7.1")
gem("ethon", "0.8.0")
gem("typhoeus", "0.8.0")
gem("faraday_middleware", "0.9.1")
gem("rubyzip", "1.1.7", require_name: "zip")
gem("upsert", "2.1.0")
gem("ruby-progressbar", "1.7.5")

register_asset("stylesheets/base/variables.css.scss")
register_asset("stylesheets/components/breadcrumb.css.scss")
register_asset("stylesheets/components/charts.css.scss")
register_asset("stylesheets/components/switch.css.scss")
register_asset("stylesheets/views/headlines.css.scss")

require(File.expand_path("../lib/headlines", __FILE__))

Discourse::Application.routes.append do
  mount Headlines::Engine, at: "/security-headers"
end

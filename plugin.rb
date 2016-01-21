# name: headlines
# about: Security vulnerabilities scanner
# version: 0.0.1
# author: SourceClear

gem("concurrent-ruby", "1.0.0", require_name: "concurrent")
gem("interactor", "3.1.0")
gem("interactor-rails", "2.0.1", require_name: "interactor/rails")
gem("iso_country_codes", "0.7.1")
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

after_initialize do
  require(File.expand_path("../app/models/user", __FILE__))
  require(File.expand_path("../app/jobs/headlines/scheduled/collect_domains_country", __FILE__))
  require(File.expand_path("../app/jobs/headlines/scheduled/base", __FILE__))
  require(File.expand_path("../app/jobs/headlines/scheduled/daily", __FILE__))
  require(File.expand_path("../app/jobs/headlines/scheduled/weekly", __FILE__))
  require(File.expand_path("../app/jobs/headlines/scheduled/monthly", __FILE__))
  require(File.expand_path("../app/jobs/headlines/regular/scan_domain", __FILE__))
  require(File.expand_path("../app/mailers/security_headers_report_mailer", __FILE__))
end

Discourse::Application.routes.append do
  mount Headlines::Engine, at: "/security-headers"
end

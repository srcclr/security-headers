FactoryGirl.define do
  factory :domains_category, class: "Headlines::DomainsCategory" do
    domain
    category
  end
end

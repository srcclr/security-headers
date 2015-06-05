FactoryGirl.define do
  factory :domain, class: "Headlines::Domain" do
    ignore { category nil }

    name  { FFaker::Internet.domain_name }
    rank "1"
    country_code "US"

    after(:create) do |domain, evaluator|
      if category = evaluator.category
        FactoryGirl.create(
          :domains_category,
          domain: domain,
          category: category
        )
      end
    end

    trait :with_data_alexa do
      data_alexa { File.read(Headlines::Engine.root.join("spec/support/fixtures/alexa_data.xml")) }
    end
  end
end

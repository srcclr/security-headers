FactoryGirl.define do
  factory :domain, class: "Headlines::Domain" do
    ignore { category nil }

    name  { FFaker::Internet.domain_name }
    sequence(:rank)

    country_code "US"

    after(:create) do |domain, evaluator|
      category = evaluator.category

      if category
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

    trait :with_scan do
      after(:create) do |domain|
        FactoryGirl.create(:scan, domain: domain)
      end
    end
  end
end

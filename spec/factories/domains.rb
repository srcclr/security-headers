FactoryGirl.define do
  factory :domain, class: "Headlines::Domain" do
    name "google.com"
    rank "1"
    country_code "US"

    trait :with_data_alexa do
      data_alexa { File.read(Headlines::Engine.root.join("spec/support/fixtures/alexa_data.xml")) }
    end
  end
end

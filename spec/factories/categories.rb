FactoryGirl.define do
  factory :category, class: "Headlines::Category" do
    title "Business and Economy/Shopping"
    topic "Top/Regional/Asia/India/Business_and_Economy/Shopping"

    trait :with_domains do
      after(:build) do |category|
        FactoryGirl.create_list(:domain, 2, category: category)
      end
    end
  end
end

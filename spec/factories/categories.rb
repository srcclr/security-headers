FactoryGirl.define do
  factory :category, class: "Headlines::Category" do
    title "Business and Economy/Shopping"
    topic "Top/Regional/Asia/India/Business_and_Economy/Shopping"

    trait :with_domains do
      after(:build) do |category|
        FactoryGirl.create_list(:domain, 2, category: category)
      end
    end

    trait :with_parents do
      after(:create) do |category|
        category.update_attributes!(parents: [category.id, category.category_id].compact)
      end
    end
  end
end

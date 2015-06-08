FactoryGirl.define do
  factory :scan, class: "Headlines::Scan" do
    domain
    results { Hash[Headlines::SECURITY_HEADERS.map { |header| [header, rand(1..100)] }] }
  end
end

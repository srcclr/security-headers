FactoryGirl.define do
  factory :scan, class: "Headlines::Scan" do
    results { Hash[Headlines::SECURITY_HEADERS.map { |header| [header, rand(-15..0)] }] }
    score 0
  end
end

FactoryGirl.define do
  factory :scan, class: "Headlines::Scan" do
    headers { [{ name: "strict-transport-security", value: "" }, { name: "x-xss-protection", value: "some value" }] }
    results { Hash[Headlines::SECURITY_HEADERS.map { |header| [header, rand(-15..0)] }] }
    score 0
  end
end

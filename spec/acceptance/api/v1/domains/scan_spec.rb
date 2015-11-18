require "rails_helper"

describe "/api/v1/domains/scan", type: :request do
  let(:params) { { url: url } }
  let(:url) { "github.com" }

  before do
    stub_request(:get, "http://#{url}/").to_return(domain_response)

    post "/api/v1/domains/scan", params
  end

  context "Successful scan" do
    let(:domain_response) do
      {
        status: 200,
        body: "",
        headers: {
          "x-xss-protection" => "1; mode=block",
          "public-key-pins" => "max-age=300; includeSubDomains",
          "x-content-type-options" => "nosniff"
        }
      }
    end

    let(:scan_result) do
      {
        "strict-transport-security" => { "value" => "", "score" => -1 },
        "x-xss-protection" => { "value" => "1; mode=block", "score" => 2 },
        "x-frame-options" => { "value" => "", "score" => -1 },
        "public-key-pins" => { "value" => "max-age=300; includeSubDomains", "score" => 0 },
        "x-permitted-cross-domain-policies" => { "value" => "", "score" => 0 },
        "x-content-type-options" => { "value" => "nosniff", "score" => 1 },
        "x-download-options" => { "value" => "", "score" => 0 },
        "content-security-policy" => { "value" => "", "score" => -15 }
      }
    end

    it "return scanned headers with rating" do
      expect(response.status).to eq(200)
      expect(response.body).to eq(scan_result.to_json)
    end
  end

  context "Failing scan" do
    let(:domain_response) { { status: 500 } }

    it "return error status code" do
      expect(response.status).to eq(422)
    end
  end
end

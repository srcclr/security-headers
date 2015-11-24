require "rails_helper"

describe "/api/v1/scan", type: :request do
  let(:params) { { url: url } }
  let(:url) { "github.com" }

  shared_examples_for "Scan using method" do |method_name|
    before do
      stub_request(:get, "http://#{url}/").to_return(domain_response)

      send method_name, "headlines/api/v1/scan", params
    end

    context "Successful scan" do
      let(:domain_response) do
        {
          status: 200,
          body: "",
          headers: {
            "x-xss-protection" => "1; mode=block",
            "public-key-pins" => "max-age=300; includeSubDomains",
            "x-content-type-options" => "nosniff",
            "content-type" => "text/html;charset=utf-8"
          }
        }
      end

      let(:scan_result) do
        {
          "strict-transport-security" => { "value" => "", "rating" => "ERROR" },
          "x-xss-protection" => { "value" => "1; mode=block", "rating" => "OK" },
          "x-frame-options" => { "value" => "", "rating" => "ERROR" },
          "public-key-pins" => { "value" => "max-age=300; includeSubDomains", "rating" => "WARN" },
          "x-permitted-cross-domain-policies" => { "value" => "", "rating" => "WARN" },
          "x-content-type-options" => { "value" => "nosniff", "rating" => "OK" },
          "x-download-options" => { "value" => "", "rating" => "WARN" },
          "x-powered-by" => { "value" => "", "rating" => "OK" },
          "server" => { "value" => "", "rating" => "OK" },
          "content-type" => { "value" => "text/html;charset=utf-8", "rating" => "OK" },
          "content-security-policy" => { "value" => "", "rating" => "ERROR" }
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

  it_behaves_like "Scan using method", :get
  it_behaves_like "Scan using method", :post
end

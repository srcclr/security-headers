require "rails_helper"

module Headlines
  describe ParseSecurityHeaders do
    let(:url) { "google.com" }
    let(:headers) { JSON.parse(open_fixture("headers.json").read) }

    subject(:context) { described_class.call(url: url) }

    before do
      stub_request(:get, url).to_return(status: 200, headers: headers)
    end

    describe ".call" do
      it "parses security headers" do
        expect(context.headers.size).to eq 4
      end
    end
  end
end

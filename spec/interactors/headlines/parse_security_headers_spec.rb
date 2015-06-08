require "rails_helper"

module Headlines
  describe ParseSecurityHeaders do
    let(:headers) { JSON.parse(open_fixture("headers.json").read) }

    subject(:context) { described_class.call(url: url) }

    describe ".call" do
      context "with existing site name" do
        before { stub_request(:get, "google.com").to_return(status: 200, headers: headers) }

        let(:url) { "google.com" }

        it { is_expected.to be_a_success }

        it "parses security headers" do
          expect(context.headers.size).to eq 4
        end
      end

      context "with fake site name" do
        before { stub_request(:get, "fakesitedomainname.com").to_raise(Faraday::ConnectionFailed) }

        let(:url) { "fakesitedomainname.com" }

        it { is_expected.to be_a_failure }

        its(:message) { is_expected.to eq "Couldn't connect to site: fakesitedomainname.com." }
      end

      context "with server error status" do
        before { stub_request(:get, "serverwith500respondstatus.com").to_return(status: 500) }
        let(:url) { "serverwith500respondstatus.com" }

        it { is_expected.to be_a_failure }
      end
    end
  end
end

require "rails_helper"

module Headlines
  describe ParseSecurityHeaders do
    let(:headers) { JSON.parse(open_fixture("headers.json").read) }
    let(:url) { "google.com" }

    subject(:context) { described_class.call(url: url) }

    describe ".call" do
      context "with existing site name" do
        before { stub_request(:get, "google.com").to_return(status: 200, headers: headers) }

        it { is_expected.to be_a_success }

        it "parses security headers" do
          expect(context.headers.size).to eq(11)
        end
      end

      context "with fake site name" do
        before { stub_request(:any, "google.com").to_raise(Faraday::ConnectionFailed) }

        it { is_expected.to be_a_failure }

        its(:message) { is_expected.to eq "Couldn't connect to site: google.com." }
      end

      context "with server error status" do
        before { stub_request(:get, "google.com").to_return(status: 500) }

        it { is_expected.to be_a_failure }
      end

      context "with domain that has PUBLIC-KEY-PINS-REPORT-ONLY header" do
        before { stub_request(:get, "google.com").to_return(status: 200, headers: headers) }

        it "parses this header" do
          expect(context.headers.map(&:name)).to include("public-key-pins")
        end
      end

      context "with domain that respond to HEAD request" do
        before { stub_request(:head, "google.com").to_return(status: 200, headers: headers) }

        context "with raised ClientError for GET request" do
          before { stub_request(:get, "google.com").to_raise(Faraday::ClientError) }

          it { is_expected.to be_a_success }
        end

        context "with raised TimeOutError for GET request" do
          before { stub_request(:get, "google.com").to_raise(Errno::ETIMEDOUT) }

          it { is_expected.to be_a_success }
        end
      end
    end
  end
end

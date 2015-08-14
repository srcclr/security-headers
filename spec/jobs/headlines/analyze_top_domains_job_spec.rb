require "rails_helper"

module Headlines
  describe AnalyzeTopDomainsJob do
    let!(:google_domain) { create(:domain, name: "google.com") }
    let!(:twitter_domain) { create(:domain, name: "twitter.com", rank: 2) }
    let(:headers) { JSON.parse(open_fixture("headers.json").read) }

    subject(:job) { described_class.new.perform }

    context "with alive domains" do
      before do
        stub_request(:get, "google.com").to_return(status: 200, headers: headers)
        stub_request(:get, "twitter.com").to_return(status: 200, headers: headers)
      end

      it "create scan results for all domains" do
        expect { job }.to change { Scan.count }.by(2)
      end
    end

    context "with some dead domains" do
      before do
        stub_request(:get, "google.com").to_raise(Faraday::ConnectionFailed)
        stub_request(:get, "twitter.com").to_return(status: 200, headers: headers)
      end

      it "create scan results for alive domains" do
        expect { job }.to change { Scan.count }.by(1)
      end
    end

    context "with all dead domains" do
      before do
        stub_request(:get, "google.com").to_raise(Faraday::ConnectionFailed)
        stub_request(:get, "twitter.com").to_raise(Faraday::ConnectionFailed)
      end

      it "doesn't create scan results" do
        expect { job }.not_to change { Scan.count }
      end
    end
  end
end

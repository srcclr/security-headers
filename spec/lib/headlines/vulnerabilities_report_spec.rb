module Headlines
  describe VulnerabilitiesReport do
    let(:scan_results) { JSON.parse(open_fixture("scan_results.json").read) }

    describe "#report" do
      subject(:report) { described_class.new(scan_results).report }

      its(["x-frame-options"]) { is_expected.to eq 50 }
      its(["x-xss-protection"]) { is_expected.to eq 0 }
      its(["x-content-type-options"]) { is_expected.to eq 100 }
      its(["content-security-policy"]) { is_expected.to eq 50 }
      its(["strict-transport-security"]) { is_expected.to eq 100 }
    end
  end
end

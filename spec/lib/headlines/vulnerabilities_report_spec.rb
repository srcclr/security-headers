module Headlines
  describe VulnerabilitiesReport do
    let(:scan_results) { JSON.parse(open_fixture("scan_results.json").read) }

    describe "#report" do
      subject(:report) { described_class.new(scan_results).report }

      its(["x-frame-options"]) { is_expected.to eq(50) }
      its(["x-xss-protection"]) { is_expected.to eq(100) }
      its(["x-content-type-options"]) { is_expected.to eq(0) }
      its(["strict-transport-security"]) { is_expected.to eq(0) }
      its(["x-download-options"]) { is_expected.to eq(0) }
      its(["public-key-pins"]) { is_expected.to eq(0) }
      its(["x-permitted-cross-domain-policies"]) { is_expected.to eq(0) }
    end
  end
end

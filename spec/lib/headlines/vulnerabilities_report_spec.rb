module Headlines
  describe VulnerabilitiesReport do
    let(:scan_results) { JSON.parse(open_fixture("scan_results.json").read) }

    describe "#report" do
      subject(:report) { described_class.new(scan_results).report }

      its(["x_frame_options"]) { is_expected.to eq 50 }
      its(["x_xss_protection"]) { is_expected.to eq 0 }
      its(["x_content_type_options"]) { is_expected.to eq 100 }
      its(["content_security_policy"]) { is_expected.to eq 50 }
      its(["strict_transport_security"]) { is_expected.to eq 100 }
    end
  end
end

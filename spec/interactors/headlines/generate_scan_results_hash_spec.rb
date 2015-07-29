require "rails_helper"

module Headlines
  describe GenerateScanResultsHash do
    let(:x_xss_protection) { SecurityHeaders::XXssProtection.new("x-xss-protection", "1; mode=block") }
    let(:x_frame_options) { SecurityHeaders::XFrameOptions.new("x-frame-options", "SAMEORIGIN") }
    let(:headers) { [x_xss_protection, x_frame_options] }

    describe ".call" do
      describe "success for any headers" do
        subject(:context) { described_class.call(headers: headers) }

        it { is_expected.to be_a_success }

        its(:scan_results) { is_expected.to be_present }
        its("scan_results.size") { is_expected.to eq 7 }
      end

      describe "returns properly headers score values" do
        subject(:scan_results) { described_class.call(headers: headers).scan_results }

        its(["x-xss-protection"]) { is_expected.to eq 2 }
        its(["x-frame-options"]) { is_expected.to eq 100 }
        its(["strict-transport-security"]) { is_expected.to eq 0 }
        its(["x-content-type-options"]) { is_expected.to eq 0 }
        its(["content-security-policy"]) { is_expected.to eq 0 }
      end

      describe "calculates domain score" do
        subject(:score) { described_class.call(headers: headers).score }

        it { is_expected.to eq 14.571428571428571 }
      end
    end
  end
end

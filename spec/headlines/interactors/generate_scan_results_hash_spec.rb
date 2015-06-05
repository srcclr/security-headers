require "rails_helper"

module Headlines
  describe GenerateScanResultsHash do
    let(:x_xss_protection) { SecurityHeaders::XXssProtection.new("x-xss-protection", "1; mode=block") }
    let(:x_frame_options) { SecurityHeaders::XFrameOptions.new("x-frame-options", "SAMEORIGIN") }
    let(:headers) { [x_xss_protection, x_frame_options] }

    subject(:context) { described_class.call(headers: headers) }

    describe ".call" do
      it { is_expected.to be_a_success }

      it "provides scan results" do
        expect(context.scan_results).to be_present
        expect(context.scan_results.size).to eq 2
        expect(context.scan_results).to have_key("x-xss-protection")
        expect(context.scan_results).to have_key("x-frame-options")
      end
    end
  end
end

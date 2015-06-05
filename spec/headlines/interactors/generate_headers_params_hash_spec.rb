require "rails_helper"

module Headlines
  describe GenerateHeadersParamsHash do
    let(:x_xss_protection) { SecurityHeaders::XXssProtection.new("x-xss-protection", "1; mode=block") }
    let(:x_frame_options) { SecurityHeaders::XFrameOptions.new("x-frame-options", "SAMEORIGIN") }
    let(:headers) { [x_xss_protection, x_frame_options] }

    subject(:context) { described_class.call(headers: headers) }

    describe ".call" do
      it { is_expected.to be_a_success }

      its(:params) { is_expected.to be_present }
      its("params.size") { is_expected.to eq 2 }
    end
  end
end

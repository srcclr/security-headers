require "rails_helper"

module Headlines
  describe GenerateResults do
    let(:x_xss_protection) { SecurityHeaders::XXssProtection.new("x-xss-protection", "1; mode=block") }
    let(:x_frame_options) { SecurityHeaders::XFrameOptions.new("x-frame-options", "SAMEORIGIN") }
    let(:headers) { [x_xss_protection, x_frame_options] }

    describe ".call" do
      describe "success for any headers" do
        subject(:context) { described_class.call(headers: headers) }

        it { is_expected.to be_a_success }

        it "return hash with parameters" do
          expect(context.params).to be_present
          expect(context.params.size).to eq(7)
        end
      end

      describe "returns properly headers score values" do
        subject(:scan_results) { described_class.call(headers: headers).params[:results] }

        it "returns scores for given headers" do
          expect(scan_results["x-xss-protection"]).to eq(2)
          expect(scan_results["x-frame-options"]).to eq(2)
        end
      end

      describe "calculates domain score" do
        subject(:params) { described_class.call(headers: headers).params }

        it "returns domain scores" do
          expect(params[:http_score]).to eq(2)
          expect(params[:csp_score]).to eq(0)
          expect(params[:score]).to eq(2)
        end
      end
    end
  end
end

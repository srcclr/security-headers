module Headlines
  module SecurityHeaders
    describe SecurityHeader do
      describe "#initialize" do
        subject(:instance) { described_class.new(header) }

        context "with header" do
          let(:header) { ["some-security-header", "at least one parameter"] }

          it "set parameters" do
            expect(instance.params[:enabled]).to be_truthy
            expect(instance.params[:value]).to eq "at least one parameter"
          end
        end

        context "without header" do
          let(:header) { ["some-security-header"] }

          it "set parameters" do
            expect(instance.params[:enabled]).to be_truthy
            expect(instance.params[:value]).to be_nil
          end
        end
      end

      describe "#score" do
        let(:header) { ["some-security-header", "at least one parameter"] }

        subject(:score) { described_class.new(header).score }

        it { is_expected.to eq 1 }
      end
    end
  end
end

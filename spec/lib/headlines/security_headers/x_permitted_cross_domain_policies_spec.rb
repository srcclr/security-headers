module Headlines
  module SecurityHeaders
    describe XPermittedCrossDomainPolicies do
      let(:name) { "x-permitted-cross-domain-policies" }

      describe "#score" do
        subject(:score) { described_class.new(name, value).score }

        context "when value is master-only" do
          let(:value) { "master-only" }

          it { is_expected.to eq(1) }
        end

        context "when value is blank" do
          let(:value) { "" }

          it { is_expected.to eq(0) }
        end
      end
    end
  end
end

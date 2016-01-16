module Headlines
  describe DataAlexa::Parser do
    let(:alexa_data) { open_fixture("alexa_data.xml").read }

    describe "#country_code" do
      subject { described_class.new(alexa_data).country_code }

      it { is_expected.to eq "IN" }
    end

    describe "#request_limit?" do
      subject { described_class.new(alexa_data).request_limit? }

      context "with successfull response" do
        it { is_expected.to be_falsey }
      end

      context "with failure response" do
        let(:alexa_data) { open_fixture("fail_alexa_data.xml").read }

        it { is_expected.to be_truthy }
      end
    end
  end
end

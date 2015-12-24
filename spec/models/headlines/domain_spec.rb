module Headlines
  describe Domain do
    describe "#data_alexa=" do
      let(:domain) { described_class.new }
      let(:data_alexa) { open_fixture("alexa_data.xml").read }

      subject(:update_data_alexa) { domain.data_alexa = data_alexa }

      it "updates country_code" do
        expect { update_data_alexa }.to change { domain.country_code }.to("IN")
      end

      it "updates refresh_data_alexa flag" do
        expect { update_data_alexa }.to change { domain.refresh_data_alexa }.to(false)
      end
    end
  end
end

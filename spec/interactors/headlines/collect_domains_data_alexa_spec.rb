require "rails_helper"

module Headlines
  describe CollectDomainsDataAlexa do
    let(:xml) { "<xml>I'm xml" }
    let(:progressbar) { double("progressbar") }

    describe ".call" do
      before do
        allow_any_instance_of(DataAlexa).to receive(:xml).and_return(xml)
        allow(progressbar).to receive(:increment)
      end

      subject { described_class.call(progressbar: progressbar, domains: [build_stubbed(:domain)]) }

      it "collects data alexa for each domain" do
        expect(subject.domains.map(&:data_alexa)).to be_present
      end
    end
  end
end

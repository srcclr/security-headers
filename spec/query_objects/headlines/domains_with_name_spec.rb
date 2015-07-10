require "rails_helper"

module Headlines
  describe DomainsWithName do
    let!(:domain) { create(:domain, name: "heydomain.com") }

    before { create(:domain) }

    describe "#all" do
      let(:params) { {} }

      subject { described_class.new(domains: Domain.all, params: params).all }

      context "when empty params value" do
        it "responds with the whole list of domains" do
          expect(subject.count).to eq 2
        end
      end

      context "when full domain name in params" do
        let(:params) { { domain_name: domain.name } }

        it "responds with domain having the same name" do
          expect(subject).to eq [domain]
        end
      end

      context "when domain_name contains only part of domain name" do
        let(:params) { { domain_name: "hey" } }

        it "responds with domain contains the part in the name" do
          expect(subject).to eq [domain]
        end
      end
    end
  end
end

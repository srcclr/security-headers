require "rails_helper"

module Headlines
  describe "Fetch industries with top domains" do
    let(:params) { {} }
    let(:industry) { create(:industry) }

    before do
      create(:category, :with_domains, industry: industry)
    end

    subject(:get_industries) { get("/headlines/industries.json", params) && response }

    it "responds with industries" do
      expect(get_industries).to be_success
    end

    context "when domains_per_industry param has been sent" do
      let(:params) { { domains_per_industry: 1 } }

      subject(:industries) { JSON.parse(get_industries.body)["industries"] }

      it "responds with limited number of domains per industry" do
        industries.each do |industry|
          expect(industry["industry_ranked_domains"].size).to be 1
        end
      end
    end
  end
end

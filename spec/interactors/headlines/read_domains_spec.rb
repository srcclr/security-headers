require "rails_helper"

module Headlines
  describe ReadDomains do
    let(:rows) { ["1,google.com", "2,www.facebook.com"] }

    describe ".call" do
      subject { described_class.call(rows: rows).domains }

      context "when handler is not given" do
        it "collects items in domains" do
          expect(subject.size).to eq 2
        end
      end
    end

    describe "domain instances" do
      subject { described_class.call(rows: rows).domains.first }

      it "represents instances of domains" do
        expect(subject).to be_kind_of(Domain)
      end

      its(:name) { is_expected.to eq "google.com" }
      its(:rank) { is_expected.to eq 1 }
    end
  end
end

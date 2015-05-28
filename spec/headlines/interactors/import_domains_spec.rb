require "rails_helper"

module Headlines
  describe ImportDomains do
    let(:file) { double("file") }
    let(:domains) { ["1,google.com", "2,www.facebook.com"] }

    before do
      allow(file).to receive(:fetch_in_batches).and_yield(domains)
    end

    subject { described_class.call(file: file).domains }

    describe ".call" do
      it "builds one item for each input line" do
        expect(subject.size).to eq 2
      end
    end

    describe "domain instances" do
      subject { described_class.call(file: file).domains.first }

      it "represents instances of domains" do
        expect(subject).to be_kind_of(Domain)
      end

      its(:name) { is_expected.to eq "google.com" }
      its(:rank) { is_expected.to eq 1 }
    end
  end
end

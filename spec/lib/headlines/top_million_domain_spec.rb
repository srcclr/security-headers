module Headlines
  describe TopMillionDomain do
    describe "#fetch_in_batches" do
      let(:batch_size) { 10 }
      let(:file) { open_fixture("top_domains.csv") }

      subject(:top) { described_class.new(file: file) }

      it "returns rows by batch size" do
        top.fetch_in_batches(batch_size: 2) do |rows|
          expect(rows.size).to eq(2)
        end
      end

      it "yields multiple times block passed to" do
        expect { |block| top.fetch_in_batches(batch_size: 2, &block) }.to yield_control.twice
      end

      context "when limit is passed" do
        it "returns only limited number of rows" do
          expect do |block|
            top.fetch_in_batches(batch_size: 2, limit: 2, &block)
          end.to yield_control.once
        end
      end

      context "when limit is bigger then batch_size" do
        it "returns number of rows set by limit option" do
          top.fetch_in_batches(batch_size: 4, limit: 2) do |rows|
            expect(rows.size).to eq 2
          end
        end
      end
    end
  end
end

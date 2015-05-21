module Headlines
  describe TopMillionDomain do

    describe '#fetch_in_batches' do
      let(:batch_size) { 10 }
      let(:file) { open_fixture('top_domains.csv') }

      subject(:top) { described_class.new(file: file) }

      it 'returns rows by batch size' do
        top.fetch_in_batches(batch_size: 2) do |rows|
          expect(rows.size).to eq(2)
        end
      end

      it 'yields multiple times block passed to' do
        expect { |block| top.fetch_in_batches(batch_size: 2, &block) }.to yield_control.twice
      end
    end
  end
end

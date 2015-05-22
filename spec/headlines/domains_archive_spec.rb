module Headlines
  describe DomainsArchive do
    let(:top_domains_zip) { open_fixture('top_domains.csv.zip') }

    before do
      stub_request(:get, described_class::URL).to_return(body: top_domains_zip, status: 200)
    end

    describe '#each_line' do
      it 'fetches domain from downloaded archive' do
        expect(described_class.new.each_line.to_a.size).to equal 4
      end
    end
  end
end

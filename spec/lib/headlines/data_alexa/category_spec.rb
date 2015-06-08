module Headlines
  describe DataAlexa::Category do
    let(:node_xml) do
      <<-XML
        <CAT
          ID="Top/Regional/Asia/India/Business_and_Economy/Shopping"
          TITLE="Business and Economy/Shopping"
          CID="498976"/>
      XML
    end

    let(:node) { Nokogiri::XML(node_xml).root }

    subject { described_class.new(node) }

    its(:path) { is_expected.to eq "Top/Regional/Asia/India/Business_and_Economy/Shopping" }
    its(:id) { is_expected.to eq "498976" }
    its(:title) { is_expected.to eq "Business and Economy/Shopping" }
  end
end

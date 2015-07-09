module Headlines
  describe Category do
    describe "#parents" do
      subject(:category) { described_class.new(parents: [1, 2], id: 1) }

      it "returns only ids of parent categories excluding self id" do
        expect(category.parents).to eq [2]
      end
    end
  end
end

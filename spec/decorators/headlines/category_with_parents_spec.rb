module Headlines
  describe CategoryWithParents do
    describe "#parents" do
      let(:category) { build_stubbed(:category, parents: parents) }

      subject { described_class.new(category) }

      context "when parents don't have any item" do
        let(:parents) { [] }

        it "returns empty list" do
          expect(subject.parents).to eq([])
        end
      end

      context "when parents contains list of parent categories" do
        let(:parents) { [1] }

        before do
          create(:category, id: 1, title: "My Category")
        end

        it "returns parent categories ids and titles" do
          expect(subject.parents.pluck(:id, :title)).to eq [[1, "My Category"]]
        end
      end
    end
  end
end

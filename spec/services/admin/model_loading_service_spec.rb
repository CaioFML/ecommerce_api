RSpec.describe Admin::ModelLoadingService do
  describe "#call" do
    subject(:call) { described_class.new(Category.all, params).call }

    let!(:categories) { create_list(:category, 15) }

    context "when params are present" do
      let!(:search_categories) do
        categories = []
        15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
        categories
      end

      let(:params) do
        { search: { name: "Search" }, order: { name: :desc }, page: 2, length: 4 }
      end

      it "returns right :length following pagination" do
        expect(call.count).to eq 4
      end

      it "returns records following search, order and pagination" do
        search_categories.sort! { |a, b| b[:name] <=> a[:name] }
        expected_categories = search_categories[4..7]

        expect(call).to contain_exactly(*expected_categories)
      end
    end

    context "when params are not present" do
      let(:params) { nil }

      it "returns default :length pagination" do
        expect(call.count).to eq 10
      end

      it "returns first 10 records" do
        expected_categories = categories[0..9]
        expect(call).to contain_exactly(*expected_categories)
      end
    end
  end
end

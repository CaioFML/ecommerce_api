describe Admin::ModelLoadingService do
  context "when #call" do
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

      it "performs right :length following pagination" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.records.count).to eq 4
      end

      it "do right search, order and pagination" do
        search_categories.sort! { |a, b| b[:name] <=> a[:name] }
        service = described_class.new(Category.all, params)
        service.call
        expected_categories = search_categories[4..7]
        expect(service.records).to contain_exactly(*expected_categories)
      end

      it "sets right :page" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.pagination[:page]).to eq 2
      end

      it "sets right :length" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.pagination[:length]).to eq 4
      end

      it "sets right :total" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it "sets right :total_pages" do
        service = described_class.new(Category.all, params)
        service.call
        expect(service.pagination[:total_pages]).to eq 4
      end
    end

    context "when params are not present" do
      it "returns default :length pagination" do
        service = described_class.new(Category.all, nil)
        service.call
        expect(service.records.count).to eq 10
      end

      it "returns first 10 records" do
        service = described_class.new(Category.all, nil)
        service.call
        expected_categories = categories[0..9]
        expect(service.records).to contain_exactly(*expected_categories)
      end

      it "sets right :page" do
        service = described_class.new(Category.all, nil)
        service.call
        expect(service.pagination[:page]).to eq 1
      end

      it "sets right :length" do
        service = described_class.new(Category.all, nil)
        service.call
        expect(service.pagination[:length]).to eq 10
      end

      it "sets right :total" do
        service = described_class.new(Category.all, nil)
        service.call
        expect(service.pagination[:total]).to eq 15
      end

      it "sets right :total_pages" do
        service = described_class.new(Category.all, nil)
        service.call
        expect(service.pagination[:total_pages]).to eq 2
      end
    end
  end
end

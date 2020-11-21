RSpec.describe Category do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  describe "associations" do
    it { is_expected.to have_many(:product_categories).dependent(:destroy) }
    it { is_expected.to have_many(:products).through(:product_categories) }
  end

  it_behaves_like "name searchable concern", :category
  it_behaves_like "paginatable concern", :category
end

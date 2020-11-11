RSpec.describe Product do
  subject { build(:product) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "associations" do
    it { is_expected.to belong_to :productable }
    it { is_expected.to have_many(:product_categories).dependent(:destroy) }
    it { is_expected.to have_many(:categories).through(:product_categories) }
  end
end
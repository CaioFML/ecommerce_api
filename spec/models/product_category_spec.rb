RSpec.describe ProductCategory do
  describe "associations" do
    it { is_expected.to belong_to :product }
    it { is_expected.to belong_to :category }
  end
end

RSpec.describe Coupon do
  describe "validations" do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to validate_presence_of :discount_value }
    it { is_expected.to validate_presence_of :max_use }
    it { is_expected.to validate_presence_of :due_date }

    it { is_expected.to validate_uniqueness_of(:code).case_insensitive }

    it { is_expected.to validate_numericality_of(:discount_value).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:max_use).only_integer.is_greater_than_or_equal_to(0) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values({ active: 1, inactive: 2 }) }
  end
end

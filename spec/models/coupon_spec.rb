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

    context "when due date is in the past" do
      before { subject.due_date = 1.day.ago }

      it "adds an error" do
        subject.valid?
        expect(subject.errors.keys).to include :due_date
      end
    end

    context "when due date is today" do
      before { subject.due_date = Time.zone.now }

      it "adds an error" do
        subject.valid?
        expect(subject.errors.keys).to include :due_date
      end
    end

    context "when due date is in the future" do
      before { subject.due_date = 1.day.from_now }

      it "does not add an error" do
        subject.valid?
        expect(subject.errors.keys).to_not include :due_date
      end
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values({ active: 1, inactive: 2 }) }
  end

  it_behaves_like "name searchable concern", :coupon
  it_behaves_like "paginatable concern", :coupon
end

RSpec.describe FutureDateValidator do
  class Validatable
    include ActiveModel::Validations

    attr_accessor :date
    validates :date, future_date: true
  end

  subject(:validatable) { Validatable.new }

  context "when date is before current date" do
    before { validatable.date = 1.day.ago }

    it { is_expected.to be_invalid }

    it "adds an error on model" do
      validatable.valid?
      expect(validatable.errors.keys).to include(:date)
    end
  end

  context "when date is equal current date" do
    before { validatable.date = Time.zone.now }

    it { is_expected.to be_invalid }

    it "adds an error on model" do
      validatable.valid?
      expect(validatable.errors.keys).to include(:date)
    end
  end

  context "when date is greater than current date" do
    before { validatable.date = 1.day.from_now }

    it { is_expected.to be_valid }
  end
end

RSpec.describe FutureDateValidator do
  class Validatable
    include ActiveModel::Validations

    attr_accessor :date
    validates :date, future_date: true
  end

  subject { Validatable.new }

  context "when date is before current date" do
    before { subject.date = 1.day.ago }

    it { is_expected.to be_invalid }

    it "adds an error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context "when date is equal current date" do
    before { subject.date = Time.zone.now }

    it { expect(subject).to be_invalid }

    it "adds an error on model" do
      subject.valid?
      expect(subject.errors.keys).to include(:date)
    end
  end

  context "when date is greater than current date" do
    before { subject.date = Time.zone.now + 1.day }

    it { is_expected.to be_valid }
  end
end

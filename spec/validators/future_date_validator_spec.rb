RSpec.describe FutureDateValidator do
  subject(:validatable) { fake_model.new }

  let(:fake_model) do
    Class.new do
      include ActiveModel::Validations

      def self.model_name
        ActiveModel::Name.new(self, nil, "FakeModel")
      end

      attr_accessor :date

      validates :date, future_date: true
    end
  end

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

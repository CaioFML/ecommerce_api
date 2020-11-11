RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:profile) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:profile).with_values({ admin: 0, client: 1 }) }
  end
end

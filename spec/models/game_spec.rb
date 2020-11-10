RSpec.describe Game do
  describe "validations" do
    it { is_expected.to validate_presence_of(:mode) }
    it { is_expected.to validate_presence_of(:release_date) }
    it { is_expected.to validate_presence_of(:developer) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:mode).with_values({ pvp: 1, pve: 2, both: 3 }) }
  end

  describe "associations" do
    it { is_expected.to belong_to :system_requirement }
    it { is_expected.to belong_to :system_requirement }
    it { is_expected.to have_one :product }
  end
end

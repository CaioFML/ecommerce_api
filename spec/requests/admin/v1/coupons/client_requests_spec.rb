RSpec.describe Admin::V1::CouponsController do
  context "with user client" do
    let(:user) { create(:user, profile: :client) }
    let!(:coupon) { create(:coupon) }

    describe "GET #index" do
      before do
        create_list(:coupon, 5)

        get admin_v1_coupons_path, headers: auth_header(user)
      end

      include_examples "forbidden access"
    end

    describe "POST #create" do
      before { post admin_v1_coupons_path, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_coupon_path(coupon), headers: auth_header(user) }

      include_examples "forbidden access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_coupon_path(coupon), headers: auth_header(user) }

      include_examples "forbidden access"
    end
  end
end

RSpec.describe Admin::V1::CouponsController do
  context "without authentication" do
    describe "GET #index" do
      before do
        create_list(:coupon, 5)

        get admin_v1_system_requirements_path
      end

      include_examples "unauthenticated access"
    end

    describe "POST #create" do
      before { post admin_v1_coupons_path }

      include_examples "unauthenticated access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_coupon_path(coupon) }

      let(:coupon) { create(:coupon) }

      include_examples "unauthenticated access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_coupon_path(coupon) }

      let!(:coupon) { create(:coupon) }

      include_examples "unauthenticated access"
    end
  end
end

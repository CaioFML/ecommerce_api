RSpec.describe Admin::V1::CouponsController do
  context "with user admin" do
    let(:user) { create(:user) }
    let(:coupons_attributes) { %i[id name code status discount_value max_use due_date] }

    describe "GET #index" do
      describe "GET #index" do
        subject(:get_index) { get admin_v1_coupons_path, headers: auth_header(user) }

        let!(:coupon) { create_list(:coupon, 5) }

        it "returns all coupons" do
          get_index

          expect(body_json["coupons"])
            .to contain_exactly(*coupon.as_json(only: coupons_attributes))
        end

        it do
          get_index

          expect(response).to have_http_status :ok
        end
      end
    end

    describe "POST #create" do
      subject(:post_create) { post admin_v1_coupons_path, headers: auth_header(user), params: params }

      context "with valid params" do
        let(:params) { { coupon: attributes_for(:coupon) }.to_json }

        it "adds a new Coupon" do
          expect { post_create }.to change(Coupon, :count).by(1)
        end

        it "returns last added Coupon" do
          post_create

          expect(body_json["coupon"]).to eq Coupon.last.as_json(only: coupons_attributes)
        end

        it do
          post_create

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { coupon: attributes_for(:coupon, name: nil) }.to_json }

        it "does not add a new SystemRequirement" do
          expect { post_create }.not_to change(SystemRequirement, :count)
        end

        it "returns error message" do
          post_create

          expect(body_json["errors"]["fields"]).to have_key("name")
        end

        it do
          post_create

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH #update" do
      subject(:patch_update) do
        patch admin_v1_coupon_path(coupon), headers: auth_header(user), params: params
      end

      let(:coupon) { create(:coupon) }

      context "with valid params" do
        let(:new_name) { "My new coupon" }
        let(:params) { { coupon: { name: new_name } }.to_json }

        it "updates coupon" do
          patch_update

          expect(coupon.reload.name).to eq new_name
        end

        it "returns updated coupon" do
          patch_update

          expect(body_json["coupon"])
            .to eq coupon.reload.as_json(only: coupons_attributes)
        end

        it do
          patch_update

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { coupon: attributes_for(:coupon, name: nil) }.to_json }

        it "does not update coupon" do
          old_name = coupon.name

          patch_update

          coupon.reload
          expect(coupon.name).to eq old_name
        end

        it "returns error message" do
          patch_update

          expect(body_json["errors"]["fields"]).to have_key("name")
        end

        it do
          patch_update

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE #destroy" do
      subject(:destroy) { delete admin_v1_coupon_path(coupon), headers: auth_header(user) }

      let!(:coupon) { create(:coupon) }

      it "removes coupon" do
        expect { destroy }.to change(Coupon, :count).by(-1)
      end

      it do
        destroy

        expect(response).to have_http_status(:no_content)
      end

      it "does not return any body content" do
        destroy

        expect(body_json).not_to be_present
      end
    end
  end
end

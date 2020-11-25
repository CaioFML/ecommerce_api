RSpec.describe Admin::V1::UsersController do
  context "with user admin" do
    let!(:user_admin) { create(:user) }
    let(:users_attributes) { %i[id name profile email] }

    describe "GET #index" do
      subject(:get_index) { get admin_v1_users_path, headers: auth_header(user_admin) }

      let!(:user) { create_list(:user, 5) << user_admin }

      it "returns all coupons" do
        get_index

        expect(body_json["users"])
          .to contain_exactly(*user.as_json(only: users_attributes))
      end

      it do
        get_index

        expect(response).to have_http_status :ok
      end
    end

    describe "POST #create" do
      subject(:post_create) { post admin_v1_users_path, headers: auth_header(user_admin), params: params }

      context "with valid params" do
        let(:params) { { user: attributes_for(:user) }.to_json }

        it "adds a new user" do
          expect { post_create }.to change(User, :count).by(1)
        end

        it "returns last added user" do
          post_create

          expect(body_json["user"]).to eq User.last.as_json(only: users_attributes)
        end

        it do
          post_create

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { user: attributes_for(:user, name: nil) }.to_json }

        it "does not add a new SystemRequirement" do
          expect { post_create }.not_to change(User, :count)
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
        patch admin_v1_user_path(user), headers: auth_header(user_admin), params: params
      end

      let(:user) { create(:user) }

      context "with valid params" do
        let(:new_name) { "My new user" }
        let(:params) { { user: { name: new_name } }.to_json }

        it "updates user" do
          patch_update

          expect(user.reload.name).to eq new_name
        end

        it "returns updated user" do
          patch_update

          expect(body_json["user"])
            .to eq user.reload.as_json(only: users_attributes)
        end

        it do
          patch_update

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { user: attributes_for(:user, name: nil) }.to_json }

        it "does not update user" do
          old_name = user.name

          patch_update

          user.reload
          expect(user.name).to eq old_name
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
      subject(:destroy) { delete admin_v1_user_path(user), headers: auth_header(user_admin) }

      let!(:user) { create(:user) }

      it "removes user" do
        expect { destroy }.to change(User, :count).by(-1)
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

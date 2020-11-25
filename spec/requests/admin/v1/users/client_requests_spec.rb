RSpec.describe Admin::V1::UsersController do
  context "with user client" do
    let(:user_client) { create(:user, profile: :client) }
    let!(:user) { create(:user) }

    describe "GET #index" do
      before do
        create_list(:user, 5)

        get admin_v1_users_path, headers: auth_header(user_client)
      end

      include_examples "forbidden access"
    end

    describe "POST #create" do
      before { post admin_v1_users_path, headers: auth_header(user_client) }

      include_examples "forbidden access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_user_path(user), headers: auth_header(user_client) }

      include_examples "forbidden access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_user_path(user), headers: auth_header(user_client) }

      include_examples "forbidden access"
    end
  end
end


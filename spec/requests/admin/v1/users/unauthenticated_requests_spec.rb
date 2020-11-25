RSpec.describe Admin::V1::UsersController do
  context "without authentication" do
    let!(:user) { create(:user) }

    describe "GET #index" do
      before do
        create_list(:user, 5)

        get admin_v1_users_path
      end

      include_examples "unauthenticated access"
    end

    describe "POST #create" do
      before { post admin_v1_users_path }

      include_examples "unauthenticated access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_user_path(user) }

      include_examples "unauthenticated access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_user_path(user) }

      include_examples "unauthenticated access"
    end
  end
end

RSpec.describe Admin::V1::CategoriesController do
  context "with user client" do
    let(:user) { create(:user, profile: :client) }

    describe "GET #index" do
      before do
        create_list(:category, 5)

        get admin_v1_categories_path, headers: auth_header(user)
      end

      include_examples "forbidden access"
    end

    describe "POST #create" do
      before { post admin_v1_categories_path, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_category_path(category), headers: auth_header(user) }

      let(:category) { create(:category) }

      include_examples "forbidden access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_category_path(category), headers: auth_header(user) }

      let!(:category) { create(:category) }

      include_examples "forbidden access"
    end
  end
end

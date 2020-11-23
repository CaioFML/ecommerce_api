RSpec.describe Admin::V1::CategoriesController do
  context "without authentication" do
    describe "GET #index" do
      before do
        create_list(:category, 5)

        get admin_v1_categories_path
      end

      include_examples "unauthenticated access"
    end

    describe "POST #create" do
      before { post admin_v1_categories_path }

      include_examples "unauthenticated access"
    end

    describe "PATCH #update" do
      before { patch admin_v1_category_path(category) }

      let(:category) { create(:category) }

      include_examples "unauthenticated access"
    end

    describe "DELETE #destroy" do
      before { delete admin_v1_category_path(category) }

      let!(:category) { create(:category) }

      include_examples "unauthenticated access"
    end
  end
end

RSpec.describe "Admin::V1::Categories without authentication" do
  context "GET #index" do
    before { get admin_v1_categories_path }

    let!(:categories) { create_list(:category, 5) }

    include_examples "unauthenticated access"
  end

  context "POST #create" do
    before { post admin_v1_categories_path }

    include_examples "unauthenticated access"
  end

  context "PATCH #update" do
    before { patch admin_v1_category_path(category) }

    let(:category) { create(:category) }

    include_examples "unauthenticated access"
  end

  context "DELETE #destroy" do
    before { delete admin_v1_category_path(category) }

    let!(:category) { create(:category) }

    include_examples "unauthenticated access"
  end
end

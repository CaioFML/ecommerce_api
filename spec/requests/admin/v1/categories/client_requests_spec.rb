RSpec.describe "Admin::V1::Categories as :client" do
  let(:user) { create(:user, profile: :client) }

  context "GET #index" do
    before { get admin_v1_categories_path, headers: auth_header(user) }

    let!(:categories) { create_list(:category, 5) }

    include_examples "forbidden access"
  end

  context "POST #create" do
    before { post admin_v1_categories_path, headers: auth_header(user) }

    include_examples "forbidden access"
  end

  context "PATCH #update" do
    before { patch admin_v1_category_path(category), headers: auth_header(user) }

    let(:category) { create(:category) }

    include_examples "forbidden access"
  end

  context "DELETE #destroy" do
    before { delete admin_v1_category_path(category), headers: auth_header(user) }

    let!(:category) { create(:category) }

    include_examples "forbidden access"
  end
end

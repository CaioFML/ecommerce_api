RSpec.describe Admin::V1::CategoriesController do
  let(:user) { create(:user) }

  context "GET /categories" do
    subject(:get_index) { get admin_v1_categories_path, headers: auth_header(user) }

    let!(:categories) { create_list(:category, 5) }

    it "returns all Categories" do
      get_index

      expect(body_json["categories"]).to contain_exactly *categories.as_json(only: %i(id name))
    end

    it "returns success status" do
      get_index

      expect(response).to have_http_status :ok
    end
  end
end

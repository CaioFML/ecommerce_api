RSpec.describe Admin::V1::CategoriesController do
  let(:user) { create(:user) }

  context "GET /categories" do
    subject(:get_index) { get admin_v1_categories_path, headers: auth_header(user) }

    let!(:categories) { create_list(:category, 5) }

    it "returns all Categories" do
      get_index

      expect(body_json["categories"]).to contain_exactly *categories.as_json(only: %i(id name))
    end

    it do
      get_index

      expect(response).to have_http_status :ok
    end
  end

  context "POST /categories" do
    subject(:post_create) { post admin_v1_categories_path, headers: auth_header(user), params: params }

    context "with valid params" do
      let(:params) { { category: attributes_for(:category) }.to_json }

      it "adds a new Category" do
        expect { post_create }.to change(Category, :count).by(1)
      end

      it "returns last added Category" do
        post_create

        expected_category = Category.last.as_json(only: %i(id name))
        expect(body_json['category']).to eq expected_category
      end

      it do
        post_create

        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:params) { { category: attributes_for(:category, name: nil) }.to_json }

      it "does not add a new Category" do
        expect { post_create }.to_not change(Category, :count)
      end

      it "returns error message" do
        post_create

        expect(body_json['errors']['fields']).to have_key('name')
      end

      it do
        post_create

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context "PATCH /categories/:id" do
    subject(:patch_update) { patch admin_v1_category_path(category), headers: auth_header(user), params: params }

    let(:category) { create(:category) }

    context "with valid params" do
      let(:new_name) { 'My new Category' }
      let(:params) { { category: { name: new_name } }.to_json }

      it "updates Category" do
        patch_update

        expect(category.reload.name).to eq new_name
      end

      it "returns updated Category" do
        patch_update

        expect(body_json['category']).to eq category.reload.as_json(only: %i(id name))
      end

      it do
        patch_update

        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      let(:params) { { category: attributes_for(:category, name: nil) }.to_json }

      it 'does not update Category' do
        old_name = category.name

        patch_update

        category.reload
        expect(category.name).to eq old_name
      end

      it 'returns error message' do
        patch_update

        expect(body_json['errors']['fields']).to have_key('name')
      end

      it do
        patch_update

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end

RSpec.describe Admin::V1::CategoriesController do
  context "with user admin" do
    let(:user) { create(:user) }

    describe "GET #index" do
      let(:url) { "/admin/v1/categories" }
      let!(:categories) { create_list(:category, 10) }

      context "without any params" do
        it "returns 10 Categories" do
          get url, headers: auth_header(user)
          expect(body_json["categories"].count).to eq 10
        end

        it "returns 10 first Categories" do
          get url, headers: auth_header(user)
          expected_categories = categories[0..9].as_json(only: %i[id name])
          expect(body_json["categories"]).to contain_exactly(*expected_categories)
        end

        it "returns success status" do
          get url, headers: auth_header(user)
          expect(response).to have_http_status(:ok)
        end
      end

      context "with search[name] param" do
        let!(:search_name_categories) do
          categories = []
          15.times { |n| categories << create(:category, name: "Search #{n + 1}") }
          categories
        end

        let(:search_params) { { search: { name: "Search" } } }

        it "returns only seached categories limited by default pagination" do
          get url, headers: auth_header(user), params: search_params
          expected_categories = search_name_categories[0..9].map do |category|
            category.as_json(only: %i[id name])
          end
          expect(body_json["categories"]).to contain_exactly(*expected_categories)
        end

        it "returns success status" do
          get url, headers: auth_header(user), params: search_params
          expect(response).to have_http_status(:ok)
        end
      end

      context "with pagination params" do
        let(:pagination_params) { { page: 2, length: 5 } }

        it "returns records sized by :length" do
          get url, headers: auth_header(user), params: pagination_params
          expect(body_json["categories"].count).to eq 5
        end

        it "returns categories limited by pagination" do
          get url, headers: auth_header(user), params: pagination_params
          expected_categories = categories[5..9].as_json(only: %i[id name])
          expect(body_json["categories"]).to contain_exactly(*expected_categories)
        end

        it "returns success status" do
          get url, headers: auth_header(user), params: pagination_params
          expect(response).to have_http_status(:ok)
        end
      end

      context "with order params" do
        let(:order_params) { { order: { name: "desc" } } }

        it "returns ordered categories limited by default pagination" do
          get url, headers: auth_header(user), params: order_params
          categories.sort! { |a, b| b[:name] <=> a[:name] }
          expected_categories = categories[0..9].as_json(only: %i[id name])
          expect(body_json["categories"]).to contain_exactly(*expected_categories)
        end

        it "returns success status" do
          get url, headers: auth_header(user), params: order_params
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "GET #show" do
      let(:category) { create(:category) }
      let(:url) { "/admin/v1/categories/#{category.id}" }

      it "returns requested Category" do
        get url, headers: auth_header(user)
        expected_category = category.as_json(only: %i[id name])
        expect(body_json["category"]).to eq expected_category
      end

      it "returns success status" do
        get url, headers: auth_header(user)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST #create" do
      subject(:post_create) { post admin_v1_categories_path, headers: auth_header(user), params: params }

      context "with valid params" do
        let(:params) { { category: attributes_for(:category) }.to_json }

        it "adds a new Category" do
          expect { post_create }.to change(Category, :count).by(1)
        end

        it "returns last added Category" do
          post_create

          expected_category = Category.last.as_json(only: %i[id name])
          expect(body_json["category"]).to eq expected_category
        end

        it do
          post_create

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { category: attributes_for(:category, name: nil) }.to_json }

        it "does not add a new Category" do
          expect { post_create }.not_to change(Category, :count)
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
      subject(:patch_update) { patch admin_v1_category_path(category), headers: auth_header(user), params: params }

      let(:category) { create(:category) }

      context "with valid params" do
        let(:new_name) { "My new Category" }
        let(:params) { { category: { name: new_name } }.to_json }

        it "updates Category" do
          patch_update

          expect(category.reload.name).to eq new_name
        end

        it "returns updated Category" do
          patch_update

          expect(body_json["category"]).to eq category.reload.as_json(only: %i[id name])
        end

        it do
          patch_update

          expect(response).to have_http_status(:ok)
        end
      end

      context "with invalid params" do
        let(:params) { { category: attributes_for(:category, name: nil) }.to_json }

        it "does not update Category" do
          old_name = category.name

          patch_update

          category.reload
          expect(category.name).to eq old_name
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
      subject(:destroy) { delete admin_v1_category_path(category), headers: auth_header(user) }

      let!(:category) { create(:category) }

      it "removes Category" do
        expect { destroy }.to change(Category, :count).by(-1)
      end

      it do
        destroy

        expect(response).to have_http_status(:no_content)
      end

      it "does not return any body content" do
        destroy

        expect(body_json).not_to be_present
      end

      it "removes all associated product categories" do
        product_categories = create_list(:product_category, 3, category: category)

        destroy

        expected_product_categories = ProductCategory.where(id: product_categories.map(&:id))
        expect(expected_product_categories.count).to eq 0
      end

      it "does not remove unassociated product categories" do
        product_categories = create_list(:product_category, 3)

        destroy

        present_product_categories_ids = product_categories.map(&:id)
        expected_product_categories = ProductCategory.where(id: present_product_categories_ids)
        expect(expected_product_categories.ids).to contain_exactly(*present_product_categories_ids)
      end
    end
  end
end

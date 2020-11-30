RSpec.describe Admin::V1::ProductsController do
  context "with user client" do
    let(:user) { create(:user, profile: :client) }

    context "GET /products" do
      let(:url) { "/admin/v1/products" }
      let!(:products) { create_list(:product, 5) }

      before { get url, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    context "POST /products" do
      let(:url) { "/admin/v1/products" }

      before { post url, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    context "GET /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { get url, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    context "PATCH /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { patch url, headers: auth_header(user) }

      include_examples "forbidden access"
    end

    context "DELETE /products/:id" do
      let!(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { delete url, headers: auth_header(user) }

      include_examples "forbidden access"
    end
  end
end

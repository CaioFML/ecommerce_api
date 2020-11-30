RSpec.describe Admin::V1::ProductsController do
  context "without authentication" do
    context "GET /products" do
      let(:url) { "/admin/v1/products" }
      let!(:products) { create_list(:product, 5) }

      before { get url }

      include_examples "unauthenticated access"
    end

    context "POST /products" do
      let(:url) { "/admin/v1/products" }

      before { post url }

      include_examples "unauthenticated access"
    end

    context "GET /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { get url }

      include_examples "unauthenticated access"
    end

    context "PATCH /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { patch url }

      include_examples "unauthenticated access"
    end

    context "DELETE /products/:id" do
      let!(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { delete url }

      include_examples "unauthenticated access"
    end
  end
end

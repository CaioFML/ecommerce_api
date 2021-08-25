RSpec.describe Admin::V1::ProductsController do
  context "without authentication" do
    describe "GET /products" do
      let(:url) { "/admin/v1/products" }
      let(:products) { create_list(:product, 5) }

      before do
        products

        get url
      end

      include_examples "unauthenticated access"
    end

    describe "POST /products" do
      let(:url) { "/admin/v1/products" }

      before { post url }

      include_examples "unauthenticated access"
    end

    describe "GET /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { get url }

      include_examples "unauthenticated access"
    end

    describe "PATCH /products/:id" do
      let(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { patch url }

      include_examples "unauthenticated access"
    end

    describe "DELETE /products/:id" do
      let!(:product) { create(:product) }
      let(:url) { "/admin/v1/products/#{product.id}" }

      before { delete url }

      include_examples "unauthenticated access"
    end
  end
end

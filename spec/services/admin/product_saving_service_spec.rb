RSpec.describe Admin::ProductSavingService do
  describe "#call" do
    context "when sending loaded product" do
      let!(:new_categories) { create_list(:category, 2) }
      let!(:old_categories) { create_list(:category, 2) }
      let!(:product) { create(:product, categories: old_categories) }

      context "with valid params" do
        let!(:game) { product.productable }
        let(:params) do
          { name: "New product", category_ids: new_categories.map(&:id),
            productable_attributes: { developer: "New company" } }
        end

        it "updates product" do
          service = described_class.new(params, product)
          service.call
          product.reload
          expect(product.name).to eq "New product"
        end

        it "updates :productable" do
          service = described_class.new(params, product)
          service.call
          game.reload
          expect(game.developer).to eq "New company"
        end

        it "updates to new categories" do
          service = described_class.new(params, product)
          service.call
          product.reload
          expect(product.categories.ids).to contain_exactly(*new_categories.map(&:id))
        end
      end

      context "with invalid :product params" do
        let(:product_params) { attributes_for(:product, name: "") }

        it "raises NotSavedProductError" do
          expect do
            service = described_class.new(product_params, product)
            service.call
          end.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "sets validation :errors" do
          service = error_proof_call(product_params, product)
          expect(service.errors).to have_key(:name)
        end

        it "doesn't update :product" do
          expect do
            error_proof_call(product_params, product)
            product.reload
          end.not_to change(product, :name)
        end

        it "keeps old categories" do
          error_proof_call(product_params, product)
          product.reload
          expect(product.categories.ids).to contain_exactly(*old_categories.map(&:id))
        end
      end

      context "with invalid :productable params" do
        let(:game_params) { { productable_attributes: attributes_for(:game, developer: "") } }

        it "raises NotSavedProductError" do
          expect do
            service = described_class.new(game_params, product)
            service.call
          end.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "sets validation :errors" do
          service = error_proof_call(game_params, product)
          expect(service.errors).to have_key(:developer)
        end

        it "doesn't update :productable" do
          expect do
            error_proof_call(game_params, product)
            product.productable.reload
          end.not_to change(product.productable, :developer)
        end

        it "keeps old categories" do
          error_proof_call(game_params, product)
          product.reload
          expect(product.categories.ids).to contain_exactly(*old_categories.map(&:id))
        end
      end
    end

    context "without loaded product" do
      let!(:system_requirement) { create(:system_requirement) }

      context "with valid params" do
        let!(:categories) { create_list(:category, 2) }
        let(:game_params) { attributes_for(:game, system_requirement_id: system_requirement.id) }
        let(:product_params) { attributes_for(:product, productable: "game") }
        let(:params) do
          product_params.merge(category_ids: categories.map(&:id),
                               productable_attributes: game_params)
        end

        it "creates a new product" do
          expect do
            service = described_class.new(params)
            service.call
          end.to change(Product, :count).by(1)
        end

        it "creates :productable" do
          expect do
            service = described_class.new(params)
            service.call
          end.to change(Game, :count).by(1)
        end

        it "sets created product" do
          service = described_class.new(params)
          service.call
          expect(service.product).to be_kind_of(Product)
        end

        it "sets categories" do
          service = described_class.new(params)
          service.call
          expect(service.product.categories.ids).to contain_exactly(*categories.map(&:id))
        end
      end

      context "with invalid :product params" do
        let(:product_params) { attributes_for(:product, name: "", productable: "game") }
        let(:game_params) { attributes_for(:game, system_requirement_id: system_requirement.id) }
        let(:params) { product_params.merge(productable_attributes: game_params) }

        it "raises NotSavedProductError" do
          expect do
            service = described_class.new(params)
            service.call
          end.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "sets validation :errors" do
          service = error_proof_call(params)
          expect(service.errors).to have_key(:name)
        end

        it "does not create a new product" do
          expect do
            error_proof_call(params)
          end.not_to change(Product, :count)
        end

        it "does not create a :productable" do
          expect do
            error_proof_call(params)
          end.not_to change(Game, :count)
        end

        it "doen not create category association" do
          expect do
            error_proof_call(params)
          end.not_to change(ProductCategory, :count)
        end
      end

      context "with invalid :productable params" do
        let(:product_params) { attributes_for(:product, productable: "Game") }
        let(:game_params) { attributes_for(:game, developer: "", system_requirement_id: system_requirement.id) }
        let(:params) { product_params.merge(productable_attributes: game_params) }

        it "raises NotSavedProductError" do
          expect do
            service = described_class.new(params)
            service.call
          end.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "sets validation :errors" do
          service = error_proof_call(params)
          expect(service.errors).to have_key(:developer)
        end

        it "does not create a new product" do
          expect do
            error_proof_call(params)
          end.not_to change(Product, :count)
        end

        it "does not create a :productable" do
          expect do
            error_proof_call(params)
          end.not_to change(Game, :count)
        end

        it "doen not create category association" do
          expect do
            error_proof_call(params)
          end.not_to change(ProductCategory, :count)
        end
      end

      context "without :productable params" do
        let(:product_params) { attributes_for(:product) }

        it "raises NotSavedProductError" do
          expect do
            service = described_class.new(product_params)
            service.call
          end.to raise_error(Admin::ProductSavingService::NotSavedProductError)
        end

        it "does not create a new product" do
          expect do
            error_proof_call(product_params)
          end.not_to change(Product, :count)
        end

        it "sets validation :errors" do
          service = error_proof_call(product_params)
          expect(service.errors).to have_key(:productable)
        end

        it "does not create a :productable" do
          expect do
            error_proof_call(product_params)
          end.not_to change(Game, :count)
        end

        it "does not create category association" do
          expect do
            error_proof_call(product_params)
          end.not_to change(ProductCategory, :count)
        end
      end
    end
  end
end

def error_proof_call(*params)
  service = described_class.new(*params)
  begin
    service.call
  rescue StandardError => error
    Rails.logger.info error
  end
  service
end

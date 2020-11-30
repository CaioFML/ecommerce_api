module Admin
  module V1
    class CategoriesController < Admin::V1::ApiController
      before_action :load_category, only: %i[update destroy]

      def index
        @categories = load_categories
      end

      def create
        @category = Category.new(category_params)
        save_category!
      end

      def update
        @category.attributes = category_params
        save_category!
      end

      def destroy
        @category.destroy!
      rescue StandardError
        render_error(fields: @category.errors.messages)
      end

      private

      def load_category
        @category = Category.find(params[:id])
      end

      def load_categories
        permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
        Admin::ModelLoadingService.new(Category.all, permitted).call
      end

      def category_params
        return {} unless params.key?(:category)

        params.require(:category).permit(:id, :name)
      end

      def save_category!
        @category.save!
        render :show
      rescue StandardError
        render_error(fields: @category.errors.messages)
      end
    end
  end
end

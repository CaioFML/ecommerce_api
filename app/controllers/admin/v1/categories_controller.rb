class Admin::V1::CategoriesController < Admin::V1::ApiController
  def index
    @categories = Category.all
  end
end

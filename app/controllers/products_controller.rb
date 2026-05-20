class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.active.includes(:category)
    @products = @products.by_category(Category.find_by(slug: params[:category])) if params[:category].present?
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.ordered_by_price.page(params[:page]).per(12)
  end

  def show
    @product = Product.active.find_by!(slug: params[:id])
    @related = Product.active.by_category(@product.category).where.not(id: @product.id).limit(4)
  end
end
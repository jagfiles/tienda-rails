class HomeController < ApplicationController
  def index
    @featured_products = Product.active.in_stock.includes(:category).limit(8)
    @categories = Category.joins(:products).where(products: { active: true }).distinct.limit(6)
  end
end
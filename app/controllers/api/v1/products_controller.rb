module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :authenticate_from_jwt!, only: [:index, :show]

      def index
        products = Product.active.includes(:category)
        products = products.by_category(Category.find_by(slug: params[:category])) if params[:category].present?
        products = products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
        products = products.ordered_by_price.page(params[:page]).per(20)
        render json: {
          products: products.map { |p| product_json(p) },
          meta: { current_page: products.current_page, total_pages: products.total_pages }
        }
      end

      def show
        render json: product_json(Product.active.find_by!(slug: params[:id]), detailed: true)
      end

      private

      def product_json(p, detailed: false)
        h = { id: p.id, name: p.name, slug: p.slug, price: p.price, stock: p.stock, available: p.available?, category: { id: p.category.id, name: p.category.name } }
        h[:description] = p.description if detailed
        h
      end
    end
  end
end
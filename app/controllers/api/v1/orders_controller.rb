module Api
  module V1
    class OrdersController < BaseController
      def index
        render json: current_user.orders.includes(:order_items, :products).order(created_at: :desc).map { |o| order_json(o) }
      end

      def show
        render json: order_json(current_user.orders.find(params[:id]), detailed: true)
      end

      def create
        order = current_user.orders.build(shipping_address: params[:shipping_address], notes: params[:notes], status: :pending)
        ActiveRecord::Base.transaction do
          order.save!
          params[:items].each do |item|
            product = Product.lock.find(item[:product_id])
            raise ActiveRecord::Rollback unless product.stock >= item[:quantity].to_i
            order.order_items.create!(product: product, quantity: item[:quantity].to_i)
            product.decrement!(:stock, item[:quantity].to_i)
          end
          order.calculate_total
          order.save!
        end
        render json: order_json(order), status: :created
      rescue ActiveRecord::Rollback
        render json: { error: "Stock insuficiente" }, status: :unprocessable_entity
      end

      private

      def order_json(o, detailed: false)
        h = { id: o.id, status: o.status, total: o.total, created_at: o.created_at }
        h[:items] = o.order_items.map { |i| { product_name: i.product.name, quantity: i.quantity, unit_price: i.unit_price, subtotal: i.subtotal } } if detailed
        h
      end
    end
  end
end
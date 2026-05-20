class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :cancel]

  def index
    @orders = current_user.orders.includes(:order_items, :products).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @order = Order.new
    redirect_to products_path, alert: "Tu carrito está vacío." if (session[:cart] || {}).empty?
  end

  def create
    @cart = session[:cart] || {}
    return redirect_to products_path, alert: "Tu carrito está vacío." if @cart.empty?

    @order = current_user.orders.build(order_params.merge(status: :pending))

    ActiveRecord::Base.transaction do
      @order.save!
      @cart.each do |product_id, qty|
        product = Product.lock.find(product_id)
        raise ActiveRecord::Rollback, "Stock insuficiente para #{product.name}" if product.stock < qty.to_i
        @order.order_items.create!(product: product, quantity: qty.to_i)
        product.decrement!(:stock, qty.to_i)
      end
      @order.calculate_total
      @order.save!
    end

    session[:cart] = {}
    redirect_to @order, notice: "¡Pedido realizado con éxito!"
  rescue ActiveRecord::Rollback => e
    flash.now[:alert] = e.message
    render :new, status: :unprocessable_entity
  end

  def cancel
    if @order.can_cancel?
      @order.cancelled!
      redirect_to @order, notice: "Pedido cancelado."
    else
      redirect_to @order, alert: "No se puede cancelar."
    end
  end

  private

  def set_order    = @order = current_user.orders.find(params[:id])
  def order_params = params.require(:order).permit(:shipping_address, :notes)
end
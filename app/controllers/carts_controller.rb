class CartsController < ApplicationController
  def show
    cart = session[:cart] || {}
    @items = cart.filter_map { |id, qty| p = Product.find_by(id: id); p ? { product: p, quantity: qty } : nil }
    @total = @items.sum { |i| i[:product].price * i[:quantity] }
  end

  def add
    product = Product.find(params[:product_id])
    cart = session[:cart] || {}
    cart[product.id.to_s] = cart[product.id.to_s].to_i + params.fetch(:quantity, 1).to_i
    session[:cart] = cart
    redirect_back fallback_location: products_path, notice: "\"#{product.name}\" agregado al carrito."
  end

  def remove
    cart = session[:cart] || {}
    cart.delete(params[:product_id].to_s)
    session[:cart] = cart
    redirect_back fallback_location: cart_path, notice: "Producto eliminado."
  end

  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: "Carrito vaciado."
  end
end
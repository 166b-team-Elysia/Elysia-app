class Customer::OrdersController < ApplicationController

  def index
    @orders = current_user.orders.order(:order_status)
  end

  def show
    @order = Order.find_by_id(params[:id])
  end

  def create
    c_p_ids = params[:order][:product_ids].split(',')
    c_ps = current_user.cart.cart_products.where(id: c_p_ids)
    order_products_attributes = []
    c_ps.each do |cp|
      order_products_attributes << {
        product_id: cp.product_id,
        price: cp.total_price
      }
    end

    order_params = {
      user_id: current_user.id,
      total_price: c_ps.map(&:total_price).sum,
      order_products_attributes: order_products_attributes
    }

    @order = Order.new(order_params)
    if @order.save
      c_ps.destroy_all
      redirect_to customer_orders_path
    end
  end
end
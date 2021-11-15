class Customer::CartsController < ApplicationController

  # before_action :logged_in_user

  def index
    @cart_products = current_user.cart.cart_products.includes(:product)
    @cart = @cart_products.group_by(&:product)
    # byebug
  end

  def add
    product = Product.find_by_id(params[:product_id])
    if product
      @cart_product = current_user.cart.cart_products.find_or_initialize_by(product_id: product.id)
      @cart_product.number ||= 0
      @cart_product.number += 1
      if !@cart_product.save
        @errors = @cart_product.errors.full_messages.join(", ")
      end
    end
  end

  def destroy
    product = Product.find_by_id(params[:product_id])
    if product
      @cart_product = current_user.cart.cart_products.find_by(product_id: product.id)
      @cart_product.destroy if @cart_product
      # return if @cart_product.number <=@cart_product 0
      # @cart_product.number -= 1
      # if !cart_product.save
      #   @errors = cart_product.errors.full_messages.join(", ")
      # end
    end
    redirect_to customer_carts_path

  end
end
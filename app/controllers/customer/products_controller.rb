class Customer::ProductsController < ApplicationController
  before_action :set_store
  def index
    if params[:product_name]
      @products = Product.where('lower(name) LIKE ?', "%#{params[:product_name].downcase}%")
    else
      @products = @store.products.order(:id).paginate(page: params[:page], per_page: 10)
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to edit_path
    else
      render 'new'
    end
  end

  def show
    @product = @store.products.find_by_id(params[:id])
  end

  def add_review
    @review = Review.new(review_params)
    @review.save
    redirect_to customer_store_products_path(@store)
  end

  private
  def set_store
    @store = Store.find_by_id(params[:store_id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :store_id)
  end
  def review_params
    params.require(:review).permit(:user_id, :product_id, :level, :comment)
  end
end

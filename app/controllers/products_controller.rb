class ProductsController < ApplicationController
  before_action :authenticated!
  before_action :set_store
  before_action :set_product, only: %i[edit update destroy]

  def index
    @products = @store.products.order(:id).paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def update
  end

  def new
    @product = @store.products.new
  end

  def create
  end

  def destroy
  end

  private
  def set_store
    @store = Store.find_by_id(params[:store_id])
  end

  def set_product
    @product = @store.products.find_by_id(params[:id])
  end
end

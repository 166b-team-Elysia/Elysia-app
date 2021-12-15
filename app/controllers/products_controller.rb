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
    if @product.update(product_params)
      redirect_to store_products_path(@store)
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @product = @store.products.new
  end

  def create
    @product = @store.products.new(product_params)
    if @product.save 
      redirect_to store_products_path(@store)
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to store_products_path(@store), notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_store
    @store = Store.find_by_id(params[:store_id])
  end

  def set_product
    @product = @store.products.find_by_id(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :cover,:price, :store_id, :introduce)
  end
end

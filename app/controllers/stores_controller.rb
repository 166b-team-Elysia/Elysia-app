class StoresController < ApplicationController
  before_action :authenticated!
  before_action :set_store, only: %i[edit update destroy]

  def index
    @stores = Store.order(:id).paginate(page: params[:page], per_page: 10)
  end

  def edit
  end

  def update
    if @store.update(store_params)
      redirect_to stores_path
    else
      respond_to do |format|

        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(store_params)
    if @store.save 
      redirect_to stores_path
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_path, notice: "Store was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :avatar,:address, :postal_code, :state_id)
  end
end
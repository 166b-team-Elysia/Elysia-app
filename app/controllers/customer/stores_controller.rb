class Customer::StoresController < ApplicationController
  def index
    if current_user&.latitude.present?
      @stores = Store.all.sort_by do |t|
        current_user.distance(t)
      end
    else
      @stores = Store.order(:id)
    end
  end

  def show
    @store = Store.find_by_id(params[:id])
  end
end

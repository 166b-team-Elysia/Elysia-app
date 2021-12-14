class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end

  def full_width
  end
  
  def contact
  end

  def edit
    redirect_to root_path
  end

  def search
    @products = Product.all
  end

  def result
    
    @products = Product.where('lower(name) LIKE ?', "%#{params[:product_name].downcase}%")
    render 'show'
  end

  def show
    @product = Product.find(params[:id])
  end

  
end

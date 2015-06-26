class ProductsController < ApplicationController
  def index
    @products = Product.all
# To sort index products by price, low to high
    if params[:sort] == "price"
      @products = Product.order(:price)
    end
# To sort index products by price, high to low
    if params[:sort] == "price_hi"
      @products = Product.order(:price).reverse
    end

# To show a page with discount items only
    if params[:filter] == "discount"
      @products = Product.where("price <= ?", 30)
    end

# Jays way is condensed
# if params[:sort]
#  @products = @products.order(params[:sort] => params[:direction])
# end

# To show categories
    if params[:category]
      @products = @products.where(:category => params[:category])
    end

    # Search thru titles only
    if params[:search]
    # @products = @products.where(:title => params[:search])
     # wildcard example
     @products = @products.where('title LIKE ?', "%" + params[:search] + "%")
   end

  end

  def show
    if params[:id] == "random"
      @product = Product.all.sample
    else
      @product = Product.find(params[:id])
    end

    # @product = Product.find(params[:id])
  end

  def search

  end

  def new
  end

  def create
    # Assign product variable to existing Product.create
    product = Product.create({:title => params[:title], :brand => params[:brand], :price => params[:price], :description => params[:description], :category => params[:category], :image => params[:image]})
    flash[:success] = "Product Added."
    redirect_to "/products/#{product.id}"
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update({:title => params[:title], :brand => params[:brand], :price => params[:price], :description => params[:description], :category => params[:category], :image => params[:image]})
    flash[:success] = 'Product Updated.'
    redirect_to "/products/#{params[:id]}"
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    flash[:warning] = 'Product Destroyed.'
    redirect_to '/products'
  end


end

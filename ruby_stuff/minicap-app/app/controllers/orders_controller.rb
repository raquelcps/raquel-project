class OrdersController < ApplicationController

  def create
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i
    tax = product.price * quantity * 0.09
    price = product.price * quantity
    total_price = price + tax
    # Jay's way
    Order.create(:quantity => quantity, :user_id => current_user.id, :product_id => product.id, :price => price, :tax => tax, :total_price => total_price)

    # My way - I don't need all these attributes and params for the exercise that's just collecting quantity and user id
    #order = Order.create({:product_id => params[:product_id], :user_id => params[:user_id], :quantity => params[:quantity], :product_option_id => params[:product_option_id], :price => params[:price], :tax => params[:tax], :total_price => params[:total_price]})
    flash[:success] = "Product Purchased."
    redirect_to "/products/"
  end


end

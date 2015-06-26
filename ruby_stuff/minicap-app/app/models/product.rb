class Product < ActiveRecord::Base
  belongs_to :vendor
  has_many :product_options
  has_many :orders

  def discount_message
    if price < 30
      return 'Discount Item!'
    elsif price > 30
      return 'On Sale!'
    end
  end

  def subtotal
    subtotal = price
  end

  def tax
    tax = price * 0.09
  end

  def total
    return subtotal + tax
  end

end
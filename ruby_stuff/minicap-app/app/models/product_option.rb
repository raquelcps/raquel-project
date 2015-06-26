class ProductOption < ActiveRecord::Base
  belongs_to :product
  has_many :orders
end

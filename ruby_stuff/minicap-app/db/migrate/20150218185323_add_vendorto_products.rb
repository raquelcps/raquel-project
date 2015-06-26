class AddVendortoProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.string :vendor 
    end
  end
end

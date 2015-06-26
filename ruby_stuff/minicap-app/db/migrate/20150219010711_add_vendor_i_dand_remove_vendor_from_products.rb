class AddVendorIDandRemoveVendorFromProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.remove :vendor 
      t.integer :vendor_id
    end
  end
end

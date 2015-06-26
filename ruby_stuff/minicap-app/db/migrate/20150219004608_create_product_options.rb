class CreateProductOptions < ActiveRecord::Migration
  def change
    create_table :product_options do |t|
      t.string :name
      t.integer :product_id

      t.timestamps null: true
    end
  end
end

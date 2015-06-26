class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.decimal :price, precision: 7, scale: 2
      t.string :title
      t.string :image
      t.text :description
      t.string :category
      t.string :brand

      t.timestamps null: false
    end
  end
end

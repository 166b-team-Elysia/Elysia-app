class CreateCartProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :cart_products do |t|
      t.references :cart
      t.references :product
      t.integer :number, default: 0
      t.timestamps
    end
  end
end

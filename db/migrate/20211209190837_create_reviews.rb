class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.references :product
      t.references :user
      t.string :comment
      t.integer :level 
      t.timestamps
    end
  end
end

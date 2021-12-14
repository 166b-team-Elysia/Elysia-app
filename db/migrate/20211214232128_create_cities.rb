class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :abbreviation
      t.string :name
      t.references :state
      t.timestamps
    end
  end
end

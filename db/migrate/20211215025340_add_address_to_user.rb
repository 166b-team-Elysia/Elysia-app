class AddAddressToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :string
    add_column :users, :city_id, :integer, index: true
    add_column :users, :state_id, :integer, index: true
    add_column :users, :postal_code, :integer, index: true
    add_column :users, :longitude, :float
    add_column :users, :latitude, :float
  end
end

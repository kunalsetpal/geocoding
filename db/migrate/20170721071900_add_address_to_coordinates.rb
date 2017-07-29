class AddAddressToCoordinates < ActiveRecord::Migration[5.1]
  def change
    add_column :coordinates, :address, :string
  end
end

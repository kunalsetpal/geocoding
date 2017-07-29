class CreateCoordinates < ActiveRecord::Migration[5.1]
  def change
    create_table :coordinates do |t|
      t.decimal :latitute
      t.decimal :longitude

      t.timestamps
    end
  end
end

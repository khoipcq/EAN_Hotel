class CreateCityCoordinatesLists < ActiveRecord::Migration
  def change
    create_table :city_coordinates_lists do |t|
      t.integer :RegionID
      t.text :RegionName
      t.text :Coordinates

      t.timestamps
    end
  end
end

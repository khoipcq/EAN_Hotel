class CreateNeighborhoodCoordinatesLists < ActiveRecord::Migration
  def change
    create_table :neighborhood_coordinates_lists do |t|
      t.integer :RegionID
      t.text :RegionName
      t.text :Coordinates

      t.timestamps
    end
  end
end

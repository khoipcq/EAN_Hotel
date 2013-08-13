class CreatePointsOfInterestCoordinatesLists < ActiveRecord::Migration
  def change
    create_table :points_of_interest_coordinates_lists do |t|
      t.integer :RegionID
      t.string :RegionName
      t.string :RegionNameLong
      t.float :Latitude
      t.float :Longitude
      t.string :SubClassification

      t.timestamps
    end
  end
end

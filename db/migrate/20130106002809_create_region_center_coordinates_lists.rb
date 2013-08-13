class CreateRegionCenterCoordinatesLists < ActiveRecord::Migration
  def change
    create_table :region_center_coordinates_lists do |t|
      t.integer :RegionID
      t.string :RegionName
      t.float :CenterLatitude
      t.float :CenterLongitude

      t.timestamps
    end
  end
end

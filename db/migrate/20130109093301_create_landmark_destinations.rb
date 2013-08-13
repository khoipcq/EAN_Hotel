class CreateLandmarkDestinations < ActiveRecord::Migration
  def change
    create_table :landmark_destinations do |t|
      t.integer :DestinationID
      t.text :Name
      t.text :City
      t.string :StateProvince
      t.string :Country
      t.float :CenterLatitude
      t.float :CenterLongitude
      t.integer :Type

      t.timestamps
    end
  end
end

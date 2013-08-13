class CreateAirportCoordinatesLists < ActiveRecord::Migration
  def change
    create_table :airport_coordinates_lists do |t|
      t.integer :AirportID
      t.string :AirportCode
      t.string :AirportName
      t.float :Latitude
      t.float :Longitude
      t.integer :MainCityID
      t.string :CountryCode

      t.timestamps
    end
  end
end

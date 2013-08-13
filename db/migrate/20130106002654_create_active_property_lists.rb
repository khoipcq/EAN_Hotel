class CreateActivePropertyLists < ActiveRecord::Migration
  def change
    create_table :active_property_lists do |t|
      t.integer :EANHotelID
      t.integer :SequenceNumber
      t.string :Name
      t.string :Address1
      t.string :Address2
      t.string :City
      t.string :StateProvince
      t.string :PostalCode
      t.string :Country
      t.float :Latitude
      t.float :Longitude
      t.string :AirportCode
      t.integer :PropertyCategory
      t.string :PropertyCurrency
      t.float :StarRating
      t.integer :Confidence
      t.string :SupplierType
      t.string :Location
      t.string :ChainCodeID
      t.integer :RegionID
      t.float :HighRate
      t.float :LowRate
      t.string :CheckInTime
      t.string :CheckOutTime

      t.timestamps
    end
  end
end

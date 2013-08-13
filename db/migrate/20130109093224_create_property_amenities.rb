class CreatePropertyAmenities < ActiveRecord::Migration
  def change
    create_table :property_amenities do |t|
      t.integer :PropertyAmenityID
      t.integer :PropertyID
      t.text :Amenity
      t.string :AmenityMask

      t.timestamps
    end
  end
end

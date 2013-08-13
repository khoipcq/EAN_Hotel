class CreateRegionEanHotelIdMappings < ActiveRecord::Migration
  def change
    create_table :region_ean_hotel_id_mappings do |t|
      t.integer :RegionID
      t.integer :EANHotelID

      t.timestamps
    end
  end
end

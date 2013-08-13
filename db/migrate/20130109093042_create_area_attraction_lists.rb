class CreateAreaAttractionLists < ActiveRecord::Migration
  def change
    create_table :area_attraction_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :AreaAttractions

      t.timestamps
    end
  end
end

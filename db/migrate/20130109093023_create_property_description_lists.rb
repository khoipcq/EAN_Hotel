class CreatePropertyDescriptionLists < ActiveRecord::Migration
  def change
    create_table :property_description_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :PropertyDescription

      t.timestamps
    end
  end
end

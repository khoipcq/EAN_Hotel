class CreateDiningDescriptionsLists < ActiveRecord::Migration
  def change
    create_table :dining_descriptions_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :DiningDescriptions

      t.timestamps
    end
  end
end

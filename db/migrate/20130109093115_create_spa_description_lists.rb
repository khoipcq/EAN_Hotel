class CreateSpaDescriptionLists < ActiveRecord::Migration
  def change
    create_table :spa_description_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :SpaDescription

      t.timestamps
    end
  end
end

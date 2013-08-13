class CreateRecreationDescriptionLists < ActiveRecord::Migration
  def change
    create_table :recreation_description_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :RecreationDescription

      t.timestamps
    end
  end
end

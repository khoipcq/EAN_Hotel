class CreatePolicyDescriptionLists < ActiveRecord::Migration
  def change
    create_table :policy_description_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :PolicyDescription

      t.timestamps
    end
  end
end

class CreateCountryLists < ActiveRecord::Migration
  def change
    create_table :country_lists do |t|
      t.integer :CountryID
      t.string :LanguageCode
      t.string :CountryName
      t.string :CountryCode
      t.string :Transliteration
      t.integer :ContinentID

      t.timestamps
    end
  end
end

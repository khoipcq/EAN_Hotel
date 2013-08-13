class CreateStarRatings < ActiveRecord::Migration
  def change
    create_table :star_ratings do |t|
      t.integer :HotelID
      t.string :PropertyRating
      t.string :PropertyName
      t.string :Address1
      t.string :Address2
      t.string :Address3
      t.string :City
      t.string :StateProvince
      t.string :Country
      t.string :MarketingLevel

      t.timestamps
    end
  end
end

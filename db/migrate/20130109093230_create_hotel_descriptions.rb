class CreateHotelDescriptions < ActiveRecord::Migration
  def change
    create_table :hotel_descriptions do |t|
      t.integer :HotelID
      t.text :PropertyDescription
      t.string :GDSChainCode
      t.string :GDSChaincodeName

      t.timestamps
    end
  end
end

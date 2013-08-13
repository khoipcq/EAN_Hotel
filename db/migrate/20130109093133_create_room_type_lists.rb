class CreateRoomTypeLists < ActiveRecord::Migration
  def change
    create_table :room_type_lists do |t|
      t.integer :EANHotelID
      t.integer :RoomTypeID
      t.string :LanguageCode
      t.text :RoomTypeImage
      t.string :RoomTypeName
      t.text :RoomTypeDescription

      t.timestamps
    end
  end
end

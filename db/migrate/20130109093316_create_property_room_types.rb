class CreatePropertyRoomTypes < ActiveRecord::Migration
  def change
    create_table :property_room_types do |t|
      t.integer :PropertyID
      t.string :RoomCode
      t.text :RoomDescription

      t.timestamps
    end
  end
end

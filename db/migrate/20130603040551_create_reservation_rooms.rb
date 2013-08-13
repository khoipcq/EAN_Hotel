class CreateReservationRooms < ActiveRecord::Migration
  def self.up
    create_table :reservation_rooms do |t|
      t.integer :reservation_id, on_delete: :restrict
      t.string :confirm_number
      t.string :room_type
      t.string :guest_name
      t.string :bed_type
      t.string :smoking

      t.integer :adults
      t.integer :children

      t.float :rate
      t.float :taxes_fees

      t.string :status

      t.string :special_request
      t.timestamps
    end
  end
  def self.down
    drop_table :reservation_rooms
  end
end

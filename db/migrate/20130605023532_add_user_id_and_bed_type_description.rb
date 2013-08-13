class AddUserIdAndBedTypeDescription < ActiveRecord::Migration
  def up
    add_column :reservations, :user_id, :integer
    add_column :reservation_rooms, :bed_type_description, :string
  end

  def down
    remove_column :reservations, :user_id
    remove_column :reservation_rooms, :bed_type_description
  end
end

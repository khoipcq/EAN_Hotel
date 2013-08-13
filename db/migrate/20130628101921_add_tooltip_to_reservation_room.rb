class AddTooltipToReservationRoom < ActiveRecord::Migration
  def change
    add_column :reservation_rooms, :tooltip, :text
  end
end

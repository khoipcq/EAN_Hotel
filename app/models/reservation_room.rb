class ReservationRoom < ActiveRecord::Base
  belongs_to :reservation
  attr_accessible  :reservation_id, :room_type, :guest_name, :bed_type, 
                   :smoking, :adults, :children, :rate,:taxes_fees, :tooltip,
                   :status, :confirm_number, :special_request, :bed_type_description

  scope :confirmed, where('status = ?', Reservation::STATUS[:confirmed])
end

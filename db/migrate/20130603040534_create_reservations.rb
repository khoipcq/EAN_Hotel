class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
      t.string :itinerary_number, index: true
      t.string :confirm_number, index: true

      #user info
      t.string :user_name
      t.string :user_email, index: true
      t.string :user_phone

      #hotel detail
      t.string :hotel_number
      t.string :hotel_name
      t.string :hotel_address
      t.string :hotel_phone
      t.string :hotel_fax
      t.string :hotel_email
      t.string :check_in_time
      t.string :check_out_time

      #reservation detail
      t.integer :adults
      t.integer :children
      t.float :taxes_fees
      t.float :total_rate
      t.string :currency_code

      t.datetime :confirm_date
      t.datetime :check_in
      t.datetime :check_out

      #room details
      t.text :room_details
      t.text :noti_fee #notifications_fees
      t.text :cancellation_policy 

      t.text :cancel_policy_info

      #payment info
      t.string :card_holder
      t.string :card_type
      t.string :card_number
      t.float :amount_charged

      #billing address
      t.string :billing_name
      t.string :billing_address

      t.string :status
      t.timestamps
    end
  end
  def self.down
    drop_table :reservations
  end

end

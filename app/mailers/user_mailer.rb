class UserMailer < ActionMailer::Base
  default from: "ean.elarion@gmail.com"

  helper ServiceHelper
  helper ReservationsHelper

  def cancellation_mail(email,booking_information)
    @booking_information = booking_information
    mail(:to => email, :subject => "Your reservation have been cancelled") 
  end  
  
  def confirmation_email(email,reservation,extra_data = {})
    @reservation = reservation
    @extra_data = extra_data
    mail(:to => email, :subject => "Booking Confirmation (Itinerary ##{reservation.itinerary_number})")
  end
end

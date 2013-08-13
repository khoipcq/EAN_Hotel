class ReservationsController < ApplicationController
  
  ##
  #Index pgae
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def index
  end

  ##
  #Show pgae
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def show
    @reservation = Reservation.find(params[:id])
  rescue
    if request.xhr? #This is ajax request
      render json: {text: t("message.not_found")}
    else
      render text: t("message.not_found")
    end
  end
  
  ##
  #List
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def list
    search_value = params["search"] || ""
    if !current_user.blank?
      @reservation = Reservation.where("user_id = ? and itinerary_number like ?", current_user.id, "%#{search_value}")
    end
  end
  ##
  #index pgae
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def new
  end


  ##
  #index pgae
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def edit
  end

  ##
  #Cancel a room
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::
  #*Author*::DuongDN
  #----------------------------------------------------------------------------
  def cancel
     
    reservation = Reservation.where(:id => params[:reservation_id]).first
    room_info = reservation.reservation_rooms.where(:id => params[:res_room]).first 
    @booking_information = Reservation.get_cancel_reservation_info(reservation,room_info)
    
    if request.post?
      booking_data = {
       "itinerary_id" => params[:itinerary_number],
       "confirmation_number" => params[:confirmation_number],
       "email" => params[:email]
      }
      
      (HotelService.new).cancel(booking_data)
      
      tooltip = "Booking Amount: #{room_info.rate}<br/>
      Cancellation Charge: #{room_info.rate - params[:refund].to_f}<br/>
      Refund: #{params[:refund].to_f}"
      room_info.update_attributes({:status => 'Cancelled',
                                   :rate => room_info.rate - params[:refund].to_f,
                                   :taxes_fees => 0,
                                   :tooltip => tooltip})  
                             
      
      UserMailer.cancellation_mail(reservation.user_email,@booking_information).deliver      
      reservation.update_total_rate_and_status_and_adults_and_children
      redirect_to reservation_path(params[:reservation_id])
      return     
    end
  end
  
  ##
  #Search reservation
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *email*: email address
  # * (Integer) *itinerary_number*: Itinerary Number
  #Return::
  #*Author*::DuongDN
  #----------------------------------------------------------------------------
  def search
    if(request.get?)
    elsif request.post?
      reservation = Reservation.where(itinerary_number: params[:itinerary_number],
                                       user_email: params[:email]).first
      if reservation
        redirect_to reservation_path(reservation.id)
        return
      end
      if params[:itinerary_number].blank? or params[:email].blank?
        flash[:error] = I18n.t('reservations.search.missing_information')
      else
        flash[:error] = I18n.t('reservations.search.reservation_not_found')
      end        
    end 
  end
end

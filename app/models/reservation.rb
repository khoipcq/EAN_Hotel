class Reservation < ActiveRecord::Base
 	has_many :reservation_rooms

	STATUS = {:confirmed => 'Confirmed', :cancelled => 'Cancelled', :finished => 'Finished'}

  attr_accessible :itinerary_number, :confirm_number, :user_name, :user_email, :user_phone, :hotel_number, 
  					:hotel_name, :hotel_address, :hotel_phone, :hotel_fax, :hotel_email, :check_in_time, 
  					:check_out_time, :adults, :children, :taxes_fees, :total_rate, :confirm_date, :check_in, 
  					:check_out, :room_details, :noti_fee , :cancellation_policy , :card_holder, :card_type, 
  					:card_number, :amount_charged, :billing_name, :billing_address, :status, :cancel_policy_info,
            :currency_code, :user_id


  scope :itinerary_number_and_email, lambda { |reservation_number, email|
  	where(:itinerary_number => reservation_number, :user_email => email)
  }
  
  
  #Update rate and status of booking base on their rooms information
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A  
  def update_total_rate_and_status_and_adults_and_children(refund=nil)
  	self.total_rate = 0
  	self.taxes_fees = 0
  	self.status = STATUS[:cancelled]
    self.adults = 0
    self.children = 0
    
  	self.reservation_rooms.each do |room|
			
			if status == STATUS[:cancelled]
				self.status = room.status
			end
			
			self.total_rate += room.rate
			self.total_rate += room.taxes_fees
			self.taxes_fees += room.taxes_fees
      if room.status != STATUS[:cancelled]
        self.adults += room.adults
        self.children += room.children 
			end
    end
    
    self.save
  end

  #Set finished for this room
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  
  def self.finished
  	resers = Reservation.where('check_in < ? AND status = ?', Time.now, STATUS[:confirmed])

  	resers.each do |e| 
  		e.status = STATUS[:finished]
  		e.reservation_rooms.confirmed.each do |room|
  			room.status = STATUS[:finished]
  			room.save
  		end
  		e.save
  	end
  end

  #This method is used to create a reservation
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.new_reservation(params, current_user)
    rooms = JSON.parse(params["rooms"])
    c_user_id = nil
    if !current_user.blank?
      c_user_id = current_user.id
    end
    rooms_info = get_adults_children(rooms)
    params["hotel_booking_info"] = params["book_info"]

    params["rate_info"] = params["room"]
    confirm_numbers = params["confirmationNumbers"].is_a?(Array) ? params["confirmationNumbers"] : [params["confirmationNumbers"]]

    new_reservation = Reservation.create({
      :itinerary_number => params["itineraryId"],
      :confirm_number => confirm_numbers.join(', '),

      #user info
      :user_name => params["first_name"],
      :user_email => params["email"],
      :user_phone => params["phone"],

      #hotel info
      :hotel_number => params["hotel_booking_info"]['hotelId'],
      :hotel_name => params["hotel_booking_info"]['hotelName'],
      :hotel_address => params["address"],
      :hotel_fax => '',
      :hotel_phone => '',
      :hotel_email => '',
      :check_in_time => params['check_in_time'],
      :check_out_time => params['check_out_time'],

      :check_in => get_time( get_date(params['arrival_date']) , params['check_in_time'] ),
      :check_out => get_time( get_date(params['departure_date']) , params['check_out_time'] ),

      :adults => rooms_info[:adults],
      :children => rooms_info[:children],

      :taxes_fees => params["rate_info"]['RateInfo']['ChargeableRateInfo']['@surchargeTotal'].to_f,
      :total_rate => params["rate_info"]['RateInfo']['ChargeableRateInfo']['@total'].to_f,
      :currency_code => params["rate_info"]['RateInfo']['ChargeableRateInfo']['@currencyCode'],

      :confirm_date => Time.now,

      #room details
      :room_details => params["room_detail"],
      :noti_fee => params['noti_fee'],
      :cancellation_policy => params["cancellationPolicy"],
      :cancel_policy_info => params['cancel_policy_info'],

      #payment info
      :card_holder => params['p_first_name'] + ' ' + params['p_last_name'] ,
      :card_type => params["credit_card_type"],
      :card_number => params["p_card_num"],
      :amount_charged => params["rate_info"]['RateInfo']['ChargeableRateInfo']['@total'].to_f,

      #billing address
      :billing_name => params['p_first_name'] + ' ' + params['p_last_name'],
      :billing_address => get_billing_address(params["ba_address"], params['ba_city'], params['ba_state'], params['ba_zip_code']),
      :user_id => c_user_id
    })

    #create rooms
    #rooms_rate = params["rate_info"]['RateInfo']['ChargeableRateInfo']['NightlyRatesPerRoom']
    rate_per_room = params["rate_info"]['RateInfo']['ChargeableRateInfo']['@nightlyRateTotal'].to_f / rooms.size
    tax_per_room = params["rate_info"]['RateInfo']['ChargeableRateInfo']['@surchargeTotal'].to_f / rooms.size

    if !params["confirmationNumbers"].blank?
      (1..rooms.size).each do |index|
        new_reservation.reservation_rooms.create({
          :room_type => params['rate_room_description'],
          :guest_name => params['r' + index.to_s + '_first_name'] + ' ' + params['r' + index.to_s + '_last_name'],
          :bed_type => params['r' + index.to_s + '_bed_type'],
          :smoking => ServiceHelper::SMOKING_PREFERRNCES[params['r' + index.to_s + '_smoking_type']],
          :bed_type_description => params['r' + index.to_s + '_bed_type_description'],
          :adults => rooms[index-1]['adults'].to_i,
          :children => rooms[index-1]['children'].to_i, 
          :rate => rate_per_room,
          :taxes_fees => tax_per_room,  
          :status => STATUS[:confirmed],
          :confirm_number => confirm_numbers[index-1] ? confirm_numbers[index-1] : '',
          :special_request => params['r' + index.to_s + '_special_request']
        })
      end
    end
    new_reservation.update_total_rate_and_status_and_adults_and_children
    
    
    hotelImage = HotelImageList.where(:EANHotelID => new_reservation.hotel_number).first
    hotelImage = ( hotelImage ? hotelImage.ThumbnailURL : "") 
    
    starRating = StarRating.where(:HotelID => new_reservation.hotel_number).first
    starRating = (starRating ? starRating.PropertyRating : 0)
    
    
    hotelMap = "http://maps.googleapis.com/maps/api/staticmap?center=#{params[:latitude]},#{params[:longitude]}&markers=color:blue|#{params[:latitude]},#{params[:longitude]}&zoom=16&size=400x400&sensor=false"
     
    extra_data = {
      :hotelImage => hotelImage,
      :starRating => starRating,
      :hotelMap => hotelMap,
      :room_rate_per_night => params["room_rate_per_night"]||[]
    }
    UserMailer.confirmation_email(new_reservation.user_email, new_reservation, extra_data).deliver
    new_reservation
  end
  
  #Get sumary children and adults of a booking
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.get_adults_children(rooms)
  	rooms_info = {:adults => 0, :children => 0}

  	rooms.each do |room|
  		rooms_info[:adults] += room['adults'].to_i
  		rooms_info[:children] += room['children'].to_i
  	end

  	rooms_info
  end

  #Change date format
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.get_date(date)
  	
  	begin
  		splits = date.split('/')

  		new_date = splits[2] + splits[0] + splits[1]
  	rescue Exception => e
  		new_date = ''
  	end

  	return new_date
  end

  #Change time format
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.get_time(date, time_str)
  	
    begin
      if time_str
  		  (date + ' ' + time_str).to_time
      else 
        date.to_time
      end
  	rescue Exception => e
  		''
  	end
  end

  #Format checking date
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def get_check_in_text
    if self.check_in_time
      self.check_in.strftime('%d/%m/%Y (Check in time %I:%M%p)')
    else
      self.check_in.strftime('%d/%m/%Y')
    end
  end

  #Format check out date
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def get_check_out_text
    if self.check_out_time
      self.check_out.strftime('%d/%m/%Y (Check out time %I:%M%p)')
    else 
      self.check_out.strftime('%d/%m/%Y')
    end
  end

  #Estimate refund when canceling room
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.calculate_charged_and_refund(policy_array,rate,additional_info)
    charged = 0
    refund = rate
    checkin = additional_info[:checkin]
    policy_array.each do |policy|
      is_charged = false 
      #check this policy is apply or not
      now = Time.now
      limit_time = policy['cancelTime'].split(":")
      time_zone = policy["timeZoneDescription"][4..9]
      limitdate = Time.new(checkin.year, checkin.month, checkin.day,limit_time[0],limit_time[1],0,time_zone) + 
                  policy['startWindowHours'].to_i.hours
      
      is_charged = true if limitdate < now       
      next if !is_charged     
      #caculate charge and refund
      charged+= policy['amount'].to_f if(policy['amount'])
      charged+= (policy['percent'].to_f/100)*rate if policy['percent']
      charged+= (rate/additional_info[:night_amount])*policy['nightCount'].to_i if policy['nightCount']  
          
    end
    refund-= charged
    refund = ("%0.2f" % refund).to_f
    charged = ("%0.2f" % charged).to_f
    return charged,refund
  end

  #Get billing address
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.get_billing_address(address, city = '', state = '', zip_code = '')
  	address + ', ' + city + ', ' + state + ' ' + zip_code
  end

  # Get card holder name 
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def get_card_holder_name_parts
  	parts = self.card_holder.split(' ')
  	name_parts = []
  	name_parts << parts[0]
  	name_parts << (parts[1, parts.length-1].join(' '))

  	name_parts
  end

  #Get bed type
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::N/A
  def self.get_bed_type(bed_types, bed_type_code)
  	bed_type_str = ''
  	bed_types.each do |bt|
  		if bt[0] == bed_type_code
  			bed_type_str = bt[1]
  		end
  	end

  	bed_type_str
  end
  
  def self.get_cancel_reservation_info(reservation,room_info)
    booking_information = {}
    
    booking_information['currency_code'] = reservation.currency_code    
    booking_information['itinerary_number'] = reservation.itinerary_number
    booking_information['confirmation_number'] = room_info.confirm_number
    booking_information['user_email'] = reservation.user_email
    #Reservation Details
    booking_information['hotel_name'] = reservation.hotel_name
    booking_information['address'] =    reservation.hotel_address
    booking_information['checkin'] =    reservation.check_in.strftime("%d/%m/%Y (Check in time %I:%M%p)")
    booking_information['checkout'] =   reservation.check_out.strftime("%d/%m/%Y (Check out time %I:%M%p)")
    
    #Cancellation Details
    
    booking_information['room_guest'] = room_info.guest_name
    booking_information['booking_amount'] = room_info.rate 
    #caculate charged and refund amount
    cancel_policy_list= JSON.parse(reservation.cancel_policy_info)['CancelPolicyInfo']
    night_amount = (DateTime.parse reservation.check_out.to_s).mjd - (DateTime.parse reservation.check_in.to_s).mjd 
    additional_info = {
      :checkin => reservation.check_in,
      :night_amount => night_amount
    }
    cancelation_charged, refund_amount = Reservation.calculate_charged_and_refund(cancel_policy_list,room_info.rate,additional_info) 
  
    booking_information['cancelation_charged'] = cancelation_charged      
    booking_information["refund_amount"] = refund_amount       
    #Refund Method
    booking_information["card_type"] =   reservation.card_type
    booking_information["card_holder_first_name"] = reservation.get_card_holder_name_parts[0]
    booking_information["card_holder_last_name"]  = reservation.get_card_holder_name_parts[1]
    booking_information["card_number"] = reservation.card_number
    booking_information["billing_name"] = reservation.billing_name
    booking_information["billing_address"] = reservation.billing_address
    booking_information["cancellation_policy"] = reservation.cancellation_policy  
    booking_information
  end
end

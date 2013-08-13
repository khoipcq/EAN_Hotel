class HotelsController < ApplicationController
  @@render_show = nil
  ## preprocessor
  MONEY_SIGN = {
      "USD" => "$",
      "EUR" => "&euro;",
      "AUD" => "A$",
      "GBP" => "&pound;"
    }
  DEFAUL_CURRENCY = 'USD'
  ##
  #get list of hotels
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def index
    ## store checkin-date and checkout-date
    $checkin_date = params["arrival_date"] || ""
    $checkout_date = params["departure_date"] || ""

    ## get currencies information
    @currencies = Currency.in_ague

    ## get nightly rates
     
    @money_sign = MONEY_SIGN[(!params["currencyCode"].blank?) ? params["currencyCode"] : DEFAUL_CURRENCY]
    ## get nightly rates
    @rate_filters = [
      {:name => "Any Rate", :value => "-1", :selected => 'selected'},
      {:name => "#{@money_sign}1  - #{@money_sign}100", :value => "1-100", :selected => ''},
      {:name => "#{@money_sign}100 - #{@money_sign}200", :value => "100-200", :selected => ''},
      {:name => "#{@money_sign}200 - #{@money_sign}300", :value => "200-300", :selected => ''},
      {:name => "#{@money_sign}300 - #{@money_sign}500", :value => "300-500", :selected => ''},
      {:name => "#{@money_sign}500 - #{@money_sign}1000", :value => "500-1000", :selected => ''},
      {:name => "#{@money_sign}1000+", :value => "1000-999999999", :selected => ''}
    ]


    ## get star filters
    @star_filters = [
      {:name => "Any Star Rating", :value => "1", :selected => 'selected'},
      {:name => "2 Stars (and up)", :value => "2", :selected => ''},
      {:name => "3 Stars (and up)", :value => "3", :selected => ''},
      {:name => "4 Stars (and up)", :value => "4", :selected => ''},
      {:name => "5 Stars (and up)", :value => "5", :selected => ''}
    ]
    ## get sort filters
    @sort_filters = [
      {:name => "Price (Low to High)", :value => "PRICE", :selected => ''},
      {:name => "Price (High to Low)", :value => "PRICE_REVERSE", :selected => ''},
      {:name => "Star Rating (Low to High)", :value => "QUALITY_REVERSE", :selected => ''},
      {:name => "Star Rating (High to Low)", :value => "QUALITY", :selected => 'true'}
    ]
    render "index_new"
  end

  ##
  #Show booking screen
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def show_booking_screen
    @arrival_date = params["arrival_date"] || "12/25/2012" 
    @departure_date = params["departure_date"] || "12/30/2012"
    rooms = JSON.parse(params["rooms"])
    params["number_of_rooms"] = rooms.size
    room_info1 = params["room_info1"]
    room_info2 = params["room_info2"]
    room_detail = JSON.parse(params["room_detail"])
    hotel_id = params["id"]
    # reconvert into hash
    @room = JSON.parse(params["room"])
    @money_sign = params["money_sign"]
    @room_detail = room_detail["descriptionLong"].to_s
    @room_detail_short = room_detail["description"].to_s
    @cancellationPolicy = params["cancellation_policy"].to_s
    book_room = JSON.parse(params["book_info"])
    @number_of_rooms = rooms.size
    @noti_fee = book_room["checkInInstructions"]
    @hotel_name = book_room["hotelName"]
    @hotel_id = book_room["hotelId"]
    @room_info = params["room_info"]
    @hotel_rating = params["hotel_rating"]
    @address = params["address"]
    @city = params["city"]
    @stateProvinceCode = params["stateProvinceCode"]
    @countryCode = params["countryCode"]
    @bed_types = hotel_service.get_bed_type(@room["BedTypes"])
    @smoking_preferences =  SMOKING_PREFERRNCES
    @credit_card_types = CREDIT_CARD_TYPES
    @check_in_time = params["check_in_time"]
    @check_out_time = params["check_out_time"]
  end

  ##
  #get detail of a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def show
    
    return_value = (HotelService.new).get_hotel_detail(params)
    @currencies         = return_value[:currencies]
    @hotel_link         = return_value[:otel_link]
    @destination_string = return_value[:destination_string]
    @rooms_info         = return_value[:rooms_info]
    @history_params     = return_value[:history_params]
    @currencies         = return_value[:currencies]
    @money_sign         = return_value[:money_sign]
    @hotel_info         = return_value[:hotel_info]
    @hotel_details      = return_value[:hotel_details]
    @hotel_amenities    = return_value[:hotel_amenities]
    @room_types         = return_value[:room_types]
    @hotel_images_info  = return_value[:hotel_images_info]
    @dates_of_stay      = return_value[:dates_of_stay]
    @rooms              = return_value[:rooms]
    @book_info          = return_value[:book_info]
    @hotel_address      = return_value[:hotel_address]
    @error              = return_value[:error]  
    @latitude           = return_value[:latitude]
    @longitude          = return_value[:longitude]
        
    if !@error
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @hotel }
      end
    else
      ##TODO: handle Errors here
      respond_to do |format|
        format.html { render :template => "shared/hotel_detail_error"}
        format.json  { render :json => @error }
      end
    end
  end


  def check_show
    @@render_show = true
    params["id"] = params["hotelId"]
    return_value = (HotelService.new).get_hotel_detail(params)
    @@currencies         = return_value[:currencies]
    @@hotel_link         = return_value[:otel_link]
    @@destination_string = return_value[:destination_string]
    @@rooms_info         = return_value[:rooms_info]
    @@history_params     = return_value[:history_params]
    @@currencies         = return_value[:currencies]
    @@money_sign         = return_value[:money_sign]
    @@hotel_info         = return_value[:hotel_info]
    @@hotel_details      = return_value[:hotel_details]
    @@hotel_amenities    = return_value[:hotel_amenities]
    @@room_types         = return_value[:room_types]
    @@hotel_images_info  = return_value[:hotel_images_info]
    @@dates_of_stay      = return_value[:dates_of_stay]
    @@rooms              = return_value[:rooms]
    @@book_info          = return_value[:book_info]
    @@hotel_address      = return_value[:hotel_address]
    @error               = return_value[:error]  
    @@latitude           = return_value[:latitude]
    @@longitude          = return_value[:longitude]
    if !@error
      if @@rooms.empty?
        render :js => "alert('#{I18n.t("hotels.show.no_rooms_available")}')"
      else
        render(:update) do |page|
          params.delete(:action)
          params.delete(:controller)
          page.redirect_to render_show_hotels_path(params)
        end  
      end      
    else      
      render(:update) do |page|
        page.redirect_to render_error_hotels_path
      end
    end
  end
  
  def render_show
    params.delete("is_index")
    if !@@render_show
      redirect_to hotel_path(params['id']||params["item_id"],params)
      return
    end
    @@render_show = nil
    @currencies         = @@currencies
    @hotel_link         = @@hotel_link
    @destination_string = @@destination_string
    @rooms_info         = @@rooms_info
    @history_params     = @@history_params
    @currencies         = @@currencies
    @money_sign         = @@money_sign
    @hotel_info         = @@hotel_info
    @hotel_details      = @@hotel_details
    @hotel_amenities    = @@hotel_amenities
    @room_types         = @@room_types
    @hotel_images_info  = @@hotel_images_info
    @dates_of_stay      = @@dates_of_stay
    @rooms              = @@rooms
    @book_info          = @@book_info
    @hotel_address      = @@hotel_address
    @latitude           = @@latitude
    @longitude          = @@longitude
    
    render "show"
  end
  
  def render_error
    
    @destination_string = @@destination_string
    @rooms_info = @@rooms_info
    render :template => "shared/hotel_detail_error"
  end  
  ##
  #get_price
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return:: price json data
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_price
    available_room_response = hotel_service.get_available_room(params)
    service_available_room =  process_response(available_room_response, 'HotelRoomAvailabilityResponse')
    rooms = []
    if service_available_room["status"] == OK
      available_rooms = JSON.parse(service_available_room["response"])
      bookings = available_rooms["HotelRoomAvailabilityResponse"]
      if bookings && bookings["@size"].to_i == 1
        rooms = []
        rooms << bookings["HotelRoomResponse"]
      elsif bookings && bookings["@size"].to_i > 1
        rooms = bookings["HotelRoomResponse"]
      end
    end
    render :json => {:result=> rooms}
  end
  ##
  #get status of booking
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_status
    status_booking_response = hotel_service.get_status(params)
    service_reponse = process_response(status_booking_response, 'HotelItineraryResponse')
    if service_reponse["status"] == OK
      response = JSON.parse(service_reponse["response"])
      booking = response["HotelItineraryResponse"]
      @booking_info = booking["Itinerary"].except("HotelConfirmation")
      hotels_confirmation = booking["Itinerary"]["HotelConfirmation"]
      if hotels_confirmation.kind_of? Array
        @hotels_confirmation = hotels_confirmation
        @hotel_info = @hotels_confirmation.first["Hotel"].first
      else
        @hotels_confirmation = []
        @hotels_confirmation << hotels_confirmation
        @hotel_info = hotels_confirmation["Hotel"].first
      end

      respond_to do |format|
        format.html # get_status.html.erb
        format.xml  { render :xml => @hotel }
      end
    else
      ##TODO: handle Errors here
      @error = service_reponse["error"]
      respond_to do |format|
        format.html { render :template => "shared/error"}
        format.json  { render :json => @error }
      end
    end
  end

  ##
  #cancel booking reservation
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def cancel

    cancel_booking_response = hotel_service.cancel(params)
    service_reponse = process_response(cancel_booking_response, 'HotelRoomCancellationResponse')
    if service_reponse["status"] == OK
      response = JSON.parse(service_reponse["response"])
      @cancel_response = response["HotelRoomCancellationResponse"]
      render :json => {:status => 'ok'}
    else
      ##TODO: handle Errors here
      @error = service_reponse["error"]
      render :json => {:status => 'ok'}
    end
  end

  ##
  #get bookings available of a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_bookings
    hotel_id = params["id"]
    number_of_adults1    = params["number_of_adults1"]        || "1"
    child_ages1          = params["child_ages1"]              || ""
    @room_info1 = number_of_adults1.to_s + ',' + child_ages1.to_s
    number_of_adults2    = params["number_of_adults2"]        || "1"
    child_ages2          = params["child_ages2"]              || ""
    @room_info2 = number_of_adults2.to_s + ',' + child_ages2.to_s

    params["room_info1"] = @room_info1
    params["room_info2"] = @room_info2

    booking_hotel_response = hotel_service.get_bookings(params)
    service_reponse = process_response(booking_hotel_response, 'HotelRoomAvailabilityResponse')
    if service_reponse["status"] == OK
      response = JSON.parse(service_reponse["response"])
      bookings = response["HotelRoomAvailabilityResponse"]
      @book_info = response["HotelRoomAvailabilityResponse"]
      @hotel_info = {"hotelId" => hotel_id}
      @hotel_amenities = response["HotelRoomAvailabilityResponse"]["PropertyAmenities"]

      if bookings["@size"].to_i == 1 && !@book_info.nil?
        @rooms = []
        room_image = bookings["HotelRoomResponse"]["RoomImages"]
        unless room_image.nil?
          if room_image["@size"].to_i == 1
            bookings["HotelRoomResponse"]["image_urls"] = []
            bookings["HotelRoomResponse"]["image_urls"] << room_image["RoomImage"]["url"]
          elsif room_image["@size"] > 1
            bookings["HotelRoomResponse"]["image_urls"] = []
            room_image["RoomImage"].each do |url|
              bookings["HotelRoomResponse"]["image_urls"] << url
            end
          end
        end
        @rooms << bookings["HotelRoomResponse"]
      elsif bookings["@size"].to_i > 1 && !@book_info.nil?
        bookings["HotelRoomResponse"].each do |room|
          room_image = room["RoomImages"]
          room["image_urls"] = []
          unless room_image.nil?
            if room_image["@size"].to_i == 1
              room["image_urls"] = []
              room["image_urls"] << room_image["RoomImage"]["url"]
            elsif room_image["@size"] > 1
              room["image_urls"] = []
              room_image["RoomImage"].each do |url|
                room["image_urls"] << url
              end
            end
          end
        end
        @rooms = bookings["HotelRoomResponse"]
      else
        @rooms = []
        @book_info = nil
      end

      ## get Payment Types
      locale = params["locale"] || 'en_US'
      currencyCode = params["currencyCode"] || DEFAUL_CURRENCY
      payment_types_reponse = hotel_service.get_payment_types(locale, currencyCode)
      service_reponse = process_response(payment_types_reponse, 'HotelPaymentResponse')

      respond_to do |format|
        format.html # get_bookings.html.erb
        format.xml  { render :xml => @bookings }
      end
    else
      ##TODO: handle Errors here
      @error = service_reponse["error"]
      respond_to do |format|
        format.html { render :template => "shared/error"}
        format.json  { render :json => @error }
      end
    end
  end

  ##
  #set booking to a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  # * (Integer) *id*: id of the hotel
  #Return::json data
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def set_booking
    @hotel_id = params["id"]
    booking_hotel_response = hotel_service.set_booking(params)

    service_reponse = process_response(booking_hotel_response, 'HotelRoomReservationResponse')
    if service_reponse["status"] == OK
      response = JSON.parse(service_reponse["response"])
      if response.nil?
        @book_info = nil
        @rooms = []
      else
        @book_info = response["HotelRoomReservationResponse"].except("RateInfos")
        rooms = response["HotelRoomReservationResponse"]["RateInfos"]["RateInfo"]["RoomGroup"]["Room"]
        @charge_info = response["HotelRoomReservationResponse"]["RateInfos"]["RateInfo"]["ChargeableRateInfo"]
        if !rooms.kind_of? Array
          @rooms = []
          @rooms << rooms
        else
          @rooms = rooms
        end
      end
      params["itineraryId"] = response["HotelRoomReservationResponse"]["itineraryId"]
      params["confirmationNumbers"] = response["HotelRoomReservationResponse"]["confirmationNumbers"]
      
      if response["HotelRoomReservationResponse"]['RateInfos']['RateInfo']['CancelPolicyInfoList']
        params['cancel_policy_info'] = response["HotelRoomReservationResponse"]['RateInfos']['RateInfo']['CancelPolicyInfoList'].to_json
      else
        params['cancel_policy_info'] = ''
      end
      
      if response["HotelRoomReservationResponse"]["RateInfos"]["RateInfo"]["ChargeableRateInfo"]
        params["room_rate_per_night"] = response["HotelRoomReservationResponse"]["RateInfos"]["RateInfo"]["ChargeableRateInfo"]["NightlyRatesPerRoom"]["NightlyRate"]
      end
      @reservation_temp = Reservation.new_reservation(params, current_user)  
      redirect_to @reservation_temp 

    else
      ##TODO: handle Errors here
      @error = service_reponse["error"]
      respond_to do |format|
        format.html { render :template => "shared/error"}
        format.json  { render :json => {:error => @error, :status => 'nok'} }
      end
    end
  end

  ##
  #Get hotel location to show on Google Map
  #Return:: (Hash)
  #Parameters:: (Hash) *params* has the following field
  # => (Integer) *hotelId* The Id of the hotel
  #*Author*::ChienTX
  def hotel_location
    service_data = hotel_service.get_location(params[:hotelId].to_i)
    result = false
    status = 'nok'

    if service_data[:hotel]
      #convert the JSON data to hash
      success_response = process_response(service_data[:list_hotel_response], "LocationInfoResponse")
    
      result = {
        :hotel => service_data[:hotel],
        :places => JSON.parse(success_response['response'])['LocationInfoResponse']['LocationInfos']['LocationInfo']
      }
      status = success_response['status']
    end
    respond_to do |format|
      format.json {render :json => {:data => result, :status => status}}
    end
  end

  ##
  #Get hotel location to show on Google Map
  #Return:: (Hash)
  #Parameters:: (Hash) *params* has the following field
  # => (Integer) *hotelId* The Id of the hotel
  #*Author*::KhoiPCQ
  def get_all_hotel_location
    service_data = hotel_service.get_all_hotel_location(params[:hotelIds])
    result = false
    if service_data[:hotel]
      result = {
        :places => service_data[:list_hotel_response]
      }
    end
    respond_to do |format|
      format.json {render :json => {:data => result}}
    end
  end
  ##
  #get list of hotels
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::json data
  #*Author*::NamTV
  #----------------------------------------------------------------------------
  def list
    @history_params = params
    arrival_date_obj = Date.strptime(params["arrival_date"], "%m/%d/%Y")
    departure_date_obj = Date.strptime(params["departure_date"] , "%m/%d/%Y")
    @dates_of_stay = (departure_date_obj - arrival_date_obj).to_i
            
    @money_sign = MONEY_SIGN[(!params["currencyCode"].blank?) ? params["currencyCode"] : DEFAUL_CURRENCY]
    ## get nightly rates
    @rate_filters = [
      {:name => "Any Rate", :value => "-1", :selected => 'selected'},
      {:name => "#{@money_sign}1  - #{@money_sign}100", :value => "1-100", :selected => ''},
      {:name => "#{@money_sign}100 - #{@money_sign}200", :value => "100-200", :selected => ''},
      {:name => "#{@money_sign}200 - #{@money_sign}300", :value => "200-300", :selected => ''},
      {:name => "#{@money_sign}300 - #{@money_sign}500", :value => "300-500", :selected => ''},
      {:name => "#{@money_sign}500 - #{@money_sign}1000", :value => "500-1000", :selected => ''},
      {:name => "#{@money_sign}1000+", :value => "1000-999999999", :selected => ''}
    ]

    if params[:use_local] == 'true'  ## Use local database for searching
      @hotels = HotelTest.find(
        :all,
        :conditions => ["LOWER(Name) LIKE ?", params["destination_string"]],
        :limit => 70
        )
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @hotels }
      end ## End Use local database for searching

    else ## use EAN service
      params[:use_local] = 'false'
      ## search by EAN service
      if (params["item_category"] == HotelService::ITEM_CATEGORY[:AIRPORT] || params["item_category"] == HotelService::ITEM_CATEGORY[:LANDMARK])
        list_hotel_response = hotel_service.index(params)
        service_reponse = process_response(list_hotel_response, 'HotelListResponse')
      ## search by Hotels on local database
      elsif params["item_category"] == HotelService::ITEM_CATEGORY[:HOTELS]
        id = params["item_id"]
        render(:update) do |page|          
          page.redirect_to hotel_path(id,params: params)
        end          
        #redirect_to :controller => :hotels, :action => :show, :id => id, :params => params
        return
      else
        list_hotel_response = hotel_service.index(params)
        service_reponse = process_response(list_hotel_response, 'HotelListResponse')
      end
      if service_reponse
        if service_reponse["status"] == OK
          response = JSON.parse(service_reponse["response"])

          @cache_key = "";
          @cache_location = "";
          @is_more_results = response["HotelListResponse"]["moreResultsAvailable"]
          @total_hotels = response["HotelListResponse"]["HotelList"]["activePropertyCount"]
          @cache_key = response["HotelListResponse"]["cacheKey"]
          @cache_location = response["HotelListResponse"]["cacheLocation"]
          @hotels = response["HotelListResponse"]["HotelList"]
         
          @temp =[]
          temp_not_room_rate = [] 
          if !@hotels.nil? && !@hotels["HotelSummary"].nil?
            if @hotels["HotelSummary"].instance_of?(Array)
              @hotels["HotelSummary"].each {|x|
                if (!x["RoomRateDetailsList"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"]["ChargeableRateInfo"]["@averageRate"].nil?)
                  @temp.push x
                else
                  temp_not_room_rate.push x
                end
              }

              @hotels = @temp
              if params["sort"] =="PRICE"
                @hotels = @temp.sort_by {|hsh| hsh["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"]["ChargeableRateInfo"]["@averageRate"].to_f}
              elsif params["sort"] =="PRICE_REVERSE"
               @hotels = @temp.sort_by {|hsh| hsh["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"]["ChargeableRateInfo"]["@averageRate"].to_f}.reverse
              end
              temp_not_room_rate.each do |tnrr|
                @hotels << tnrr
              end
            else
              hotel_list = []
              hotel_list << @hotels["HotelSummary"]
              hotel_list.each {|x|
                if (!x["RoomRateDetailsList"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"].nil? && !x["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"]["ChargeableRateInfo"]["@averageRate"].nil?)
                  @temp.push x
                end
              }
              @hotels = @temp
              @is_more_results = false
              
              if params["sort"] =="PRICE"
                @hotels = @temp.sort_by {|hsh| hsh["RoomRateDetailsList"]["RoomRateDetails"]["RateInfo"]["ChargeableRateInfo"]["@averageRate"].to_f}
              end
            end
            @rooms_information = params[:rooms_information]
          else
            ##TODO: handle exception with special cases here
            @hotels = []

            render :text => result(t('hotels.no_result'))
            return
          end



          ## get rooms information
          number_of_rooms = params[:search_room]
          number_of_adults = 0
          number_of_children = 0

          rooms = JSON.parse(params["rooms"])

          rooms.each_with_index do |r, index|
            number_of_adults = number_of_adults + r["adults"].to_i
            number_of_children = number_of_children + r["children"].to_i
          end

          @rooms_information = {
            :number_of_rooms => number_of_rooms,
            :number_of_adults => number_of_adults,
            :number_of_children => number_of_children,
            :rooms => rooms
          }

          respond_to do |format|
            format.html { render :layout => false }
            format.xml  { render :xml => @hotels }
          end
        else
          ##TODO: handle Errors here
          @error = service_reponse["error"]
          if @error["error_code"] == I18n.t('label.error_code.multiple_locations')
            possible_locations = []
            if @error["other_info"]
              @error["other_info"].each do |location|
                possible_location = location["city"]
                country_code = location["countryCode"]
                country = Carmen::Country.coded(country_code)
                if country && country.subregions?
                  state = country.subregions.coded(location["stateProvinceCode"])
                  if state
                    location["stateName"] = state.name
                    possible_location = possible_location + ", " + location["stateName"]
                  else
                    location["stateName"] = ''
                  end
                  possible_location = possible_location + ", " + location["countryName"]
                  possible_locations << possible_location
                end
              end
            end
            render :text => result("#{I18n.t('message.multiple_locations')} #{possible_locations.join('; ')}")
            return
          else
            render :text => result(t('hotels.no_result'))
            return
          end
        end
      end
    end
  end

  ##
  #Validate the hotel list result
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::status of search result
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def validate_hotel_list_result
    result = OK
    list_hotel_response = hotel_service.get_list_hotels_with_destination_value(params)
    service_reponse = process_response(list_hotel_response, 'HotelListResponse')
    if (service_reponse && service_reponse["status"] != OK)
      @error = service_reponse["error"]
      result = service_reponse["status"]
      if @error["error_code"] == I18n.t('label.error_code.multiple_locations')
        result = 'light_box'
      end
    end
    render :json => {:status => result.to_s}
  end
  protected
  ##
  #Get or create an instance of HotelService class
  #Return::
  #An instance of HotelService class
  #*Author*::LongPH
  def hotel_service
    @hotel_service ||= HotelService.new
  end

end

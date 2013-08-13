##
#=== HotelService
#*Author*::LongPH
#------------------------------------------------------------------------------

class HotelService < ServiceBase
  ## define constants
  ## methods
  COUNTRY_CODE = {
    "USD" => "US",
    "CAD" => "Canada",
    "BRL" => "Brazil",
    "MXN" => "Mexico",
    "EUR" => "Belgium",
    "AUD" => "Australia",
    "GBP" => "UK"
  }

  ITEM_CATEGORY = {
    AIRPORT: 'Airports',
    LANDMARK: 'Landmarks',
    HOTELS: 'Hotels',
    CITIES: 'Cities'
  }
  ##
  #get list of hotels
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def index(params)
    # test data
    cities = {
      '0'  => {:city => "Anaconda", :state => "MT"},
      '1'  => {:city => "Seattle", :state => "WA"},
      '2'  => {:city => "Sitka", :state => "AK"}
    }

    $checkin_date = params["arrival_date"] || ""
    $checkout_date = params["departure_date"] || ""

    arrival_date        = params["arrival_date"]            || "01/15/2013"
    departure_date      = params["departure_date"]          || "01/25/2013"
    number_of_results   = !params["number_of_results"].nil? ? params["number_of_results"].to_i : 100
    city                = cities["0"][:city]
    state_province_code = cities["0"][:state]
    country_code        = COUNTRY_CODE[params["currencyCode"]]
    destination_string  = params["destination_string"]      || ""
    sort_by             = params["sort"]                    || "PRICE"
    min_star            = params["minStarRating"]           || "1"
    min_rate            = params["minRate"]
    max_rate            = params["maxRate"]
    minorRev            = 20
    cache_key           = params["cacheKey"]
    cache_location      = params["cacheLocation"]
    currencyCode        = params["currencyCode"] || "USD"

    rooms = JSON.parse(params["rooms"])
    rooms_info = ""
    rooms.each_with_index do |r, index|
      rooms_info += "&room" + (index+1).to_s + "="
      rooms_info += r["adults"].to_s
      if r["ages"].size > 0
        rooms_info += "," + r["ages"].join(',')
      end
    end


    ## recheck search criteria
    if arrival_date == I18n.t('label.home_page.arrival_date')
      arrival_date = ""
      params["arrival_date"] = "N/A"
    end
    if departure_date == I18n.t('label.home_page.departure_date')
      departure_date = ""
      params["departure_date"] = "N/A"
    end
    if destination_string == I18n.t('label.home_page.destination_string')
      destination_string = ""
      params["destination_string"] = ""
    end

    ## get position (latitude, longitude) of POI
    if params["item_category"] == ITEM_CATEGORY[:AIRPORT]
      id = params["item_id"]
      airport = AirportCoordinatesList.find(
        :first,
        :conditions => {:AirportID => id}
      )
      if airport
        latitude = airport.Latitude
        longitude = airport.Longitude
      end
    elsif params["item_category"] == ITEM_CATEGORY[:LANDMARK]
      id = params["item_id"]
      landmark = LandmarkDestination.find(
        :first,
        :conditions => {:id => id}
      )
      if landmark
        latitude = landmark.CenterLatitude
        longitude = landmark.CenterLongitude
      end
    end

    action = "list"
    geoSearch_action = "geoSearch"
    ## search by POI with Landmark position or airport position
    if (params["item_category"] == ITEM_CATEGORY[:AIRPORT] || params["item_category"] == ITEM_CATEGORY[:LANDMARK])
      searchRadius      = SEARCH_RADIUS    # default: 20
      searchRadiusUnit  = SEARCH_RADIUS_UNIT    # default: MI
      list_hotel_url = web_service_url(action) +
        "&arrivalDate=" + arrival_date +
        "&departureDate=" + departure_date +
        "&numberOfResults=" + number_of_results.to_s +
        "&latitude=" + latitude.to_s +
        "&longitude=" + longitude.to_s +
        "&searchRadius=" + searchRadius +
        "&searchRadiusUnit=" + searchRadiusUnit +
        ""
    ## search by default values, see array cities
    elsif destination_string.blank?
      list_hotel_url = web_service_url(action) +
        "&city=" + city +
        "&stateProvinceCode=" + state_province_code +
        "&arrivalDate=" + arrival_date +
        "&departureDate=" + departure_date +
        "&numberOfResults=" + number_of_results.to_s +
        rooms_info +
        ""
    elsif (params["item_category"] == ITEM_CATEGORY[:CITIES])
      destinationId = ""
      geoSearch_url = web_service_url(geoSearch_action) +
        "&destinationString=" + URI::escape(destination_string).gsub("%20", "+").gsub("'", "") +
        ""
      geoSearch_response = Net::HTTP.get(URI.parse(geoSearch_url))
      service_reponse =  process_response(geoSearch_response, 'LocationInfoResponse')
      list_hotel_url = web_service_url(action) +
          "&arrivalDate=" + arrival_date +
          "&departureDate=" + departure_date +
          "&destinationString=" + URI::escape(destination_string).gsub(",%20", "+").gsub("%20", "+").gsub("'", "") +
          "&numberOfResults=" + number_of_results.to_s +
          rooms_info +
          ""
      if service_reponse && service_reponse["status"] == OK
        response = JSON.parse(service_reponse["response"])
        if response["LocationInfoResponse"]["LocationInfos"]["@size"].to_i == 1
          destinationId = response["LocationInfoResponse"]["LocationInfos"]["LocationInfo"]["destinationId"]
          list_hotel_url = web_service_url(action) +
            "&arrivalDate=" + arrival_date +
            "&departureDate=" + departure_date +
            "&destinationId=" + destinationId +
            "&numberOfResults=" + number_of_results.to_s +
            rooms_info +
            ""
        end
      end

    ## search by destination
    else
      list_hotel_url = web_service_url(action) +
        "&arrivalDate=" + arrival_date +
        "&departureDate=" + departure_date +
        "&destinationString=" + URI::escape(destination_string).gsub(",%20", "+").gsub("%20", "+").gsub("'", "") +
        "&numberOfResults=" + number_of_results.to_s +
        rooms_info +
        ""
    end
    list_hotel_url += "&sort=" + sort_by
    if !cache_key.nil? && cache_key !=""
           list_hotel_url += "&cacheKey=" + cache_key + "&cacheLocation=" + cache_location
    end
    list_hotel_url += "&minStarRating=" + min_star+"&currencyCode="+currencyCode

    if !min_rate.nil? && !max_rate.nil? && min_rate != "" && max_rate != ""
      list_hotel_url += "&minRate=" + min_rate
      list_hotel_url += "&maxRate=" + max_rate
    end
    list_hotel_response = Net::HTTP.get(URI.parse(list_hotel_url))
    list_hotel_response
  end

  ##
  #get list of hotels with destination value
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_list_hotels_with_destination_value(params)
    arrival_date        = params["arrival_date"] || "01/15/2013"
    departure_date      = params["departure_date"] || "01/25/2013"
    destination_string  = params["destination_string"] || ""
    rooms = JSON.parse(params["rooms"])
    rooms_info = ""
    rooms.each_with_index do |r, index|
      rooms_info += "&room" + (index+1).to_s + "="
      rooms_info += r["adults"].to_s
      if r["ages"].size > 0
        rooms_info += "," + r["ages"].join(',')
      end
    end
    number_of_results = 1
    list_hotel_url = web_service_url('list') +
        "&arrivalDate=" + arrival_date +
        "&departureDate=" + departure_date +
        "&destinationString=" + URI::escape(destination_string).gsub(",%20", "+").gsub("%20", "+") +
        "&numberOfResults=" + number_of_results.to_s +
        rooms_info +
        ""
    list_hotel_response = Net::HTTP.get(URI.parse(list_hotel_url))
    list_hotel_response
  end

  ##
  #get details of hotels
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def show(params)
    hotel_id = params["id"]
    action = "info"
    get_info_url = web_service_url(action) +
    "&hotelId=" + hotel_id.to_s
    detail_hotel_response = Net::HTTP.get(URI.parse(get_info_url))
    detail_hotel_response
  end

  ##
  #get payment types
  #Parameters::
  # (String) *locale*: locale object (language, country, variant)
  # (String) *currencyCode*: currency code
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_payment_types(locale, currencyCode)
    action = "paymentInfo"
    get_payment_url = web_service_url(action) +
    "&locale=" + locale.to_s +
    "&currencyCode=" + currencyCode.to_s +
    ""

    paymen_types_response = Net::HTTP.get(URI.parse(get_payment_url))
    paymen_types_response
  end

  ##
  #get status of booking
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_status(params)
    hotel_id = params["id"]
    itinerary_id = params["itinerary_id"]
    email = params["email"]

    action = "itin"
    get_status_url = web_service_url(action) +
    "&hotelId=" + hotel_id.to_s +
    "&itineraryId=" + itinerary_id.to_s +
    "&sig=" + get_sig.to_s +
    "&email=" + get_test_email

    status_booking_response = Net::HTTP.get(URI.parse(get_status_url))
    status_booking_response
  end

  ##
  #get room availability of a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_bookings(params)
    hotel_id = params["id"]
    arrival_date        = $checkin_date || params["arrival_date"]            || "01/15/2013"
    departure_date      = $checkout_date || params["departure_date"]          || "01/30/2013"
    room_info1 = params["room_info1"]
    room_info2 = params["room_info2"]

    ## recheck search criteria
    if arrival_date == I18n.t('label.home_page.arrival_date')
      arrival_date = "01/15/2013"
      params["arrival_date"] = "01/15/2013"
    end
    if departure_date == I18n.t('label.home_page.departure_date')
      departure_date = "01/30/2013"
      params["departure_date"] = "01/30/2013"
    end

    action = "avail"
    get_bookings_url = web_service_url(action) +
      "&hotelId=" + hotel_id.to_s +
      "&room1=" + room_info1 +
      "&room2=" + room_info2 +
      "&arrivalDate=" + arrival_date +
      "&departureDate=" + departure_date +
      "&includeRoomImages=" + 'true' +
      "&options=" + "HOTEL_DETAILS,ROOM_TYPES,PROPERTY_AMENITIES,ROOM_AMENITIES,HOTEL_IMAGES" +
      ""

    booking_hotel_response = Net::HTTP.get(URI.parse(get_bookings_url))
    booking_hotel_response
  end

  ##
  #cancel booking reservation
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_hotel_booking_info(hotel_info)
    address = []
    address << hotel_info['address1'].to_s
    address << hotel_info['city'].to_s
    address << hotel_info['stateProvinceCode'].to_s
    address << get_country_name(hotel_info['countryCode'].to_s)
    address.delete_if{|x| x.blank?}
    return address.join(", ")

  end

  ##
  #get room availability of a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_available_room(params)
    hotel_id = params["id"]
    arrival_date        = ($checkin_date.present?) ? $checkin_date :  (params["arrival_date"] || "01/15/2013")
    departure_date      = ($checkout_date.present?) ? $checkout_date : (params["departure_date"] || "01/30/2013")
    currencyCode = params["currencyCode"] || "USD"
    room_infos = []
    if params["rooms"] != nil
      room_infos_arr = JSON.parse(params["rooms"].to_s)
      (0..room_infos_arr.size - 1).each do |i|
        room_info = room_infos_arr[i]
        adult_num = room_info["adults"]
        child_ages = room_info["ages"].join(",")
        room_infos << "room#{i + 1}=#{adult_num}" + ((child_ages != "") ? ",#{child_ages}" : "")
      end
    end
    room_infos = ((room_infos.join("&") != "") ? ( "&" + room_infos.join("&") ) : "")
    ## recheck search criteria
    if arrival_date == I18n.t('label.home_page.arrival_date')
      arrival_date = "01/15/2013"
      params["arrival_date"] = "01/15/2013"
    end
    if departure_date == I18n.t('label.home_page.departure_date')
      departure_date = "01/30/2013"
      params["departure_date"] = "01/30/2013"
    end

    action = "avail"
    get_bookings_url = web_service_url(action) +
      "&hotelId=" + hotel_id.to_s +
      room_infos +
      "&currencyCode=" + currencyCode +
      "&arrivalDate=" + arrival_date +
      "&departureDate=" + departure_date +
      "&includeRoomImages=" + 'true' +
      "&options=" + "ROOM_TYPES,ROOM_AMENITIES,HOTEL_IMAGES" +
      "&supplierType=E&includeDetails=true"
    booking_hotel_response = Net::HTTP.get(URI.parse(get_bookings_url))
    booking_hotel_response
  end

  ##
  #set room booking of a hotel
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def set_booking(params)
    # booking information
    hotel_id = params["id"]
    arrival_date = params["arrival_date"] || "12/25/2012"
    departure_date = params["departure_date"] || "12/30/2012"
    room_info1 = params["room_info1"]
    room_info2 = params["room_info2"]
    number_of_rooms = params["number_of_rooms"]
    # reconvert into hash
    params["room"] = JSON.parse(params["room"])
    params["book_info"] = JSON.parse(params["book_info"])

    supplierType = params["room"]["supplierType"].to_s
    rateKey = params["book_info"]["rateKey"].to_s
    roomTypeCode = params["room"]["roomTypeCode"].to_s
    rateCode = params["room"]["rateCode"].to_s
    chargeableRate = params["room"]["RateInfo"]["ChargeableRateInfo"]["@total"]
    customerSessionId= params["book_info"]["customerSessionId"]

    # credit card information
    email = !params['email'].blank? ? params['email'] : get_test_email
    firstName = !params['first_name'].blank? ? params['first_name'] : 'Test Booking'
    lastName = !params['last_name'].blank? ? params['last_name'] : 'Test Booking'
    homePhone = !params['phone'].blank? ? params['phone'] : '2145370159'
    workPhone = !params['workPhone'].blank? ? params['workPhone'] : '2145370159'
    creditCardType = !params['creditCardType'].blank? ? params['creditCardType'] : 'CA'
    creditCardNumber = !params['creditCardNumber'].blank? ? params['creditCardNumber'] : '5401999999999999'
    creditCardIdentifier = !params['creditCardIdentifier'].blank? ? params['creditCardIdentifier'] : '123'
    creditCardExpirationMonth = !params['creditCardExpirationMonth'].blank? ? params['creditCardExpirationMonth'] : '11'
    creditCardExpirationYear = !params['creditCardExpirationYear'].blank? ? params['creditCardExpirationYear'] : '2013'

    user_credit_card = {
      "email" => get_test_email,
      "firstName" => firstName,
      "lastName" => lastName,
      "homePhone" => homePhone,
      "workPhone" => workPhone,
      "creditCardType" => creditCardType,
      "creditCardNumber" => creditCardNumber,
      "creditCardIdentifier" => creditCardIdentifier,
      "creditCardExpirationMonth" => creditCardExpirationMonth,
      "creditCardExpirationYear" => creditCardExpirationYear
    }

    action = "res?"
    set_booking_url = web_service_url_post(action)
    #hotel_id = 106347
    new_params = {
      "cid" => get_cid,
      "apiKey" => get_apiKey,
      "customerSessionId" => customerSessionId,
      "sig" => get_sig,
      "minorRev" => '20',

      "hotelId" => hotel_id,
      "arrivalDate" => arrival_date,
      "departureDate" => departure_date,

      "locale" => 'en_US',
      "currencyCode" => 'USD',
      "supplierType" => supplierType,
      "rateKey" => rateKey,
      "roomTypeCode" => roomTypeCode,
      "rateCode" => rateCode,
      "chargeableRate" => chargeableRate,
      "address1" => 'travelnow',
      "city" => 'Bellevue',
      "stateProvinceCode" => 'WA',
      "countryCode" => 'US',
      "postalCode" => '98004',
      "customerIpAddress" => "abc.com"      
    }
    (1..number_of_rooms.to_i).each do |room_id|
      new_params["room#{room_id}"] =  '1'
      new_params["room#{room_id}FirstName"] = !params["r#{room_id}_first_name"].blank? ? params["r#{room_id}_first_name"] : ("test" + ("s" * room_id))
      new_params["room#{room_id}LastName"] = !params["r#{room_id}_last_name"].blank? ? params["r#{room_id}_last_name"] : ("tester" + ("s" * room_id))
      new_params["room#{room_id}BedTypeId"] = !params["r#{room_id}_bed_type"].blank? ? params["r#{room_id}_bed_type"] : "23"
      new_params["room#{room_id}SmokingPreference"] = !params["r#{room_id}_smoking_preferences"].blank? ? params["r#{room_id}_smoking_preferences"] : "NS"
    end
    new_params.merge!(user_credit_card)
    uri = URI.parse(set_booking_url)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true

    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    if File.exists?('/opt/local/etc/openssl/cert.pem') # Mac OS X
      https.ca_file = '/opt/local/etc/openssl/cert.pem'
    end

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data(new_params)
    
    set_booking_response = https.start {|http| http.request(req) }
    set_booking_response = set_booking_response.body
  end

  ##
  #cancel booking reservation
  #Parameters::
  # (Hash) *params*: params from controller
  #Return::JSON data to be parsed later
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def cancel(params)

    itinerary_id = params["itinerary_id"]
    email = params["email"]
    confirmation_number = params["confirmation_number"]
    reason = params["reason"]

    action = "cancel"
    cancel_booking_url = web_service_url(action) +
      "&itineraryId=" + itinerary_id.to_s +
      "&confirmationNumber=" + confirmation_number +
      "&email=" + email +
      ""

    cancel_booking_response = Net::HTTP.get(URI.parse(cancel_booking_url))
    cancel_booking_response
  end

    ##
  #Get bed type
  #Parameters::
  # (Integer) *room_type* all room
  #Return:: array: list_rooms_facilities
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_bed_type(bed_types)
    return [] if bed_types.blank?

    list_bed_types = []
    if(bed_types['@size'].to_i == 1)#when size is 1, the value is not ARRAY ! 
      bed_types["BedType"] = [bed_types["BedType"]]   
    end
    (bed_types["BedType"]||[]).each do |bed_type|
      description = bed_type["description"]
      id = bed_type["@id"]
      if(description)
        list_bed_types << [id, description]
      end
    end

    list_bed_types
  end
  
  ##
  #Get the location of the hotel
  #Parameters::
  # (Integer) *hotelId* ID of the hotel
  #Return::JSON data to be parsed later
  #*Author*::ChienTX
  #----------------------------------------------------------------------------
  def get_location(hotelId)
    #get location of current hotel
    list_landmark_response = ""
    response = {:hotel => false, :list_hotel_response => list_landmark_response}
    hotel = ActivePropertyList.find_by_EANHotelID(hotelId)
    number_of_results = 20
    if !hotel.blank?
      #get other places around current hotel
      searchRadius      = '5'    # default: 20
      searchRadiusUnit  = 'KM'    # default: MI
      destinationString = "&destinationString=" + hotel.City.to_s + "," + hotel.StateProvince.to_s + "," + hotel.Country.to_s + "&type=2" + ""
      list_landmark_url = web_service_url("geoSearch") + URI::escape(destinationString).gsub("%20", "+")
      list_landmark_response = Net::HTTP.get(URI.parse(list_landmark_url))
      response = {:hotel => hotel, :list_hotel_response => list_landmark_response}
    end
    return response
  end

  ##
  #Get all location of hotels
  #Parameters::
  # (Integer) *hotelIds* ID of all hotels
  #Return::JSON data to be parsed later
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_all_hotel_location(hotelIds)
    #get location of current hotel
    hotel = ""
    response = {:hotel => false, :list_hotel_response => hotel}
    hotel = ActivePropertyList.find_all_by_EANHotelID(hotelIds)
    if !hotel.blank?
      response = {:hotel => true, :list_hotel_response => hotel}
    end
    return response
  end
  
  ##
  #Get all location of hotels
  #Parameters::
  # (Integer) *hotelIds* ID of all hotels
  #Return::JSON data to be parsed later
  #*Author*::KhoiPCQ
  def get_hotel_detail(params)
    return_value = {}
    
    checkin_date       =  params["arrival_date"] 
    checkout_date      =  params["departure_date"]
    
    hotel_link = params["hotel_link"]
    destination_string = params["destination_string"]
    rooms_info = (params["roomInfos"] != nil) ? (params["roomInfos"].to_s + ", ") : ""
    history_params = params["history_params"]
    detail_hotel_response = (HotelService.new).show(params)
    currencies = Currency.in_ague
    money_sign = MONEY_SIGN[params["currencyCode"] || DEFAUL_CURRENCY]
    service_reponse = process_response(detail_hotel_response, 'HotelInformationResponse')
    
    if service_reponse["status"] == OK
      response = JSON.parse(service_reponse["response"])
      latitude = response["HotelInformationResponse"]["HotelSummary"]["latitude"]
      longitude = response["HotelInformationResponse"]["HotelSummary"]["longitude"]
      
      hotel_info = response["HotelInformationResponse"]["HotelSummary"]
      hotel_details =response["HotelInformationResponse"]["HotelDetails"]
      hotel_amenities = response["HotelInformationResponse"]["PropertyAmenities"]
      room_types = response["HotelInformationResponse"]["RoomTypes"]
      hotel_images_info = response["HotelInformationResponse"]["HotelImages"]

      #Get available_room
      dates_of_stay = 1
      rooms = []
      book_info = nil
      available_room_response = get_available_room(params)
      service_available_room =  process_response(available_room_response, 'HotelRoomAvailabilityResponse')
      
      if service_available_room["status"] == OK

        
        arrival_date_obj = Date.strptime(checkin_date, "%m/%d/%Y")
        departure_date_obj = Date.strptime(checkout_date , "%m/%d/%Y")
        dates_of_stay = (departure_date_obj - arrival_date_obj).to_i

        available_rooms = JSON.parse(service_available_room["response"])
        bookings = available_rooms["HotelRoomAvailabilityResponse"]
        book_info = available_rooms["HotelRoomAvailabilityResponse"]
        if bookings["@size"].to_i == 1 && !book_info.nil?
          rooms = []
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
          rooms << bookings["HotelRoomResponse"]
        elsif bookings["@size"].to_i > 1 && !book_info.nil?
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
          rooms = bookings["HotelRoomResponse"]
        end

      end
      hotel_address = get_hotel_booking_info(hotel_info)      
      
      return_value[:latitude] = latitude
      return_value[:longitude] = longitude
      
      return_value[:currencies] = currencies
      return_value[:hotel_link] = hotel_link
      return_value[:destination_string] = destination_string
      return_value[:rooms_info] = rooms_info
      return_value[:history_params] = history_params
      return_value[:currencies] = currencies
      return_value[:money_sign] = money_sign
      return_value[:hotel_info] = hotel_info
      return_value[:hotel_details] = hotel_details
      return_value[:hotel_amenities] = hotel_amenities
      return_value[:room_types] = room_types
      return_value[:hotel_images_info] = hotel_images_info
      return_value[:dates_of_stay] = dates_of_stay
      return_value[:rooms] = rooms
      return_value[:book_info] = book_info
      return_value[:hotel_address] = hotel_address
    else
      error = service_reponse["error"]
      return_value[:error] = error
    end
    return return_value
  end
end

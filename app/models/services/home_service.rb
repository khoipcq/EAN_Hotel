##
#=== HomeService
#*Author*::LongPH
#------------------------------------------------------------------------------
class HomeService < ServiceBase

  ##
  #search result for auto-complete funtions
  #Parameters::
  # (String) *search_str*: string to be searched
  #Return::
  # (Array) *data*: results of search, include objects of
  # * ActivePropertyList ~ hotels
  # * CityCoordinatesList ~ cities
  # * AirportCoordinatesList ~ airports
  # * LandmarkDestination ~ landmarks
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def search (search_str, raw_search_str)
    ## Results to be returned
    data = []
    city_flag = false
    search_city = search_str.split(',').first
    if !search_city
      search_city = search_str
    end
      begin
        raw_cities = ThinkingSphinx.search(
          search_str,
          :classes => [CityCoordinatesList],
          :page => 1,
          :per_page => PER_PAGE_CITY,
          :star => true, 
          :rank_mode => :sph04,
          :match_mode => :extended,
          :retry_stale => true,
          :ignore_errors => true,
          :populate => true,
          :order => "@rank DESC, name_length asc"
        )
      rescue => exception
        p "EXCEPTION FOUND!!!"
        p exception
        p "END OF EXCEPTION!!!"
      end

      begin
        ## Landmarks
        raw_landmarks = ThinkingSphinx.search(
          search_str,
          :classes => [LandmarkDestination],
          :page => 1,
          :per_page => PER_PAGE_LANDMARK,
          :star => true,
          :match_mode => :extended,
          :retry_stale => true,
          :ignore_errors => true,
          :populate => true,
          :include => [:get_country]
        )
      rescue => exception
        p "EXCEPTION FOUND!!!"
        p exception
        p "END OF EXCEPTION!!!"
      end

      begin
        ## Airports
        raw_airports = ThinkingSphinx.search(
          search_str,
          :classes => [AirportCoordinatesList],
          :page => 1,
          :per_page => PER_PAGE_AIRPORT,
          :star => true,
          :match_mode => :extended,
          :retry_stale => true,
          :ignore_errors => true,
          :populate => true,
          :include => []
        )
      rescue => exception
        p "EXCEPTION FOUND!!!"
        p exception
        p "END OF EXCEPTION!!!"
      end

      begin
        ## Hotels
        raw_hotels = ThinkingSphinx.search(
          search_str,
          :classes => [ActivePropertyList],
          :page => 1,
          :per_page => PER_PAGE_HOTEL,
          :star => true,
          :match_mode => :extended,
          :retry_stale => true,
          :ignore_errors => true,
          :populate => true,
          :include => [:get_state, :get_country]
        )
      rescue => exception
        p "EXCEPTION FOUND!!!"
        p exception
        p "END OF EXCEPTION!!!"
      end
      raw_cities = raw_cities.nil? ? [] : raw_cities
      raw_landmarks = raw_landmarks.nil? ? [] : raw_landmarks
      raw_airports = raw_airports.nil? ? [] : raw_airports
      raw_hotels = raw_hotels.nil? ? [] : raw_hotels
      city_flag = (raw_cities.length != 0) ? true : false
      begin
        raw_cities.each_with_index do |c, index|
          city = {}
          city['no'] = index
          city['id'] = c.id
          city['label'] = highlight_words(c.RegionName, raw_search_str)
          city['value'] = strip_tags(city['label'])
          city['category'] = HotelService::ITEM_CATEGORY[:CITIES]
          data << city
        end
        raw_landmarks.each_with_index do |l, index|
          landmark = {}
          landmark['no'] = index
          landmark['id'] = l.id
          landmark_name = l.Name
          landmark_name += ', ' + l.City.split(',').first if !l.City.split(',').first.blank?
          landmark['label'] = landmark_name
          if !l.get_state.nil?

            landmark['label'] = landmark['label'] + ', ' + l.get_state.StateName
          end
          if !l.get_country.nil?
            landmark['label'] = landmark['label'] + ', ' + l.get_country.Name
          end
          landmark['label'] = highlight_words(landmark['label'], raw_search_str)
          landmark['value'] = strip_tags(landmark['label'])
          landmark['category'] = HotelService::ITEM_CATEGORY[:LANDMARK]
          data << landmark
        end

        raw_airports.each_with_index do |a, index|
          airport = {}
          airport['no'] = index
          airport['id'] = a.AirportID
          airport['label'] = highlight_words(a.AirportName, raw_search_str)
          airport['value'] = strip_tags(airport['label'])
          airport['category'] = HotelService::ITEM_CATEGORY[:AIRPORT]
          data << airport
        end

        raw_hotels.each_with_index do |h, index|
          hotel = {}
          hotel['no'] = index
          hotel['id'] = h.EANHotelID
          hotel['label'] = h.Name
          if !h.City.blank?
            hotel['label'] = hotel['label'] + ', ' + h.City
          end
          if !h.get_state.nil?
            hotel['label'] = hotel['label'] + ', ' + h.get_state.StateName
          end
          if !h.get_country.nil?
            hotel['label'] = hotel['label'] + ', ' + h.get_country.Name
          end
          hotel['label'] = highlight_words(hotel['label'], raw_search_str)
          hotel['value'] = strip_tags(hotel['label'])
          hotel['category'] = HotelService::ITEM_CATEGORY[:HOTELS]
          data << hotel
        end
      rescue => exception
        p "EXCEPTION FOUND!!!"
        p exception
        p "END OF EXCEPTION!!!"
      end

    results = [data, {'city_flag' => city_flag}]
  end

end

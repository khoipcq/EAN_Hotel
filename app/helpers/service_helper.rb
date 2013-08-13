 #=== ServiceHelper
#*Author*::LongPH
#------------------------------------------------------------------------------
module ServiceHelper

  ## preprocessor
  include ApplicationHelper

  ## define constant
  OK = 'ok'
  NOK = 'nok'
  SEARCH_RADIUS = "50"
  SEARCH_RADIUS_UNIT = "KM"

  #per_page for auto-complete function
  PER_PAGE_CITY     = 4
  PER_PAGE_LANDMARK = 4
  PER_PAGE_AIRPORT  = 4
  PER_PAGE_HOTEL    = 4


  TYPES = {
    'unknown' => {:code => 'UNKNOWN', :name => "unknown"},
    'unrecoverable' => {:code => "UNRECOVERABLE", :name => "unrecoverable"},
    'recoverable' => {:code => "RECOVERABLE", :name => "recoverable"},
    'agent_attention' => {:code => "AGENT_ATTENTION", :name => "agent_attention"}
  }

  CATEGORIES = {
    'authentication' => {:code => "AUTHENTICATION", :name => "authentication"},
    'data_validation' => {:code => "DATA_VALDIATION", :name => "data_validation"},
    'invalid_property_id' => {:code => "INVALID_PROPERTY_ID", :name => "invalid_property_id"},
    'restricted_check_in' => {:code => "RESTRICTED_CHECK_IN", :name => "restricted_check_in"},
    'sold_out' => {:code => "SOLD_OUT", :name => "sold_out"},
    'result_null' => {:code => "RESULT_NULL", :name => "result_null"},
    'unknown' => {:code => "UNKNOWN", :name => "unknown"},
    'exception' => {:code => "EXCEPTION", :name => "exception"},
    'unable_to_process_request' => {:code => "UNALBE_TO_PROCESS_REQUEST", :name => "unable_to_process_request"},
    'process_fail' => {:code => "PROCESS_FAIL", :name => "process_fail"},
    'data_parse_result' => {:code => "DATA_PARSE_RESULT", :name => "data_parse_result"},
    'one_room' => {:code => "ONE_ROOM", :name => "one_room"},
    'corporate_rate' => {:code => "CORPORATE_RATE", :name => "corporate_rate"},
    'hrn_quote_key_failure' => {:code => "HRN_QOUTE_KEY_FAILURE", :name => "hrn_quote_key_failure"},
    'hrn_quote_key_invalid' => {:code => "HRN_QOUTE_KEY_INVALID", :name => "hrn_quote_key_invalid"},
    'supplier_initialization' => {:code => "SUPPLIER_INITIALIZATION", :name => "supplier_initialization"},
    'supplier_router_exception' => {:code => "SUPPLIER_ROUTER_EXCEPTION", :name => "supplier_router_exception"},
    'ejb_create_exception' => {:code => "EJB_CREATE_EXCEPTION", :name => "ejb_create_exception"},
    'finder_exception' => {:code => "FINDER_EXCEPTION", :name => "finder_exception"},
    'bml_fail' => {:code => "BML_FAIL", :name => "bml_fail"},
    'supplier_communication' => {:code => "SUPPLIER_COMMUNICATION", :name => "supplier_communication"},
    'sys_offline' => {:code => "SYS_OFFLINE", :name => "sys_offline"},
    'credit_card' => {:code => "CREDIT_CARD", :name => "credit_card"},
    'csv_fail' => {:code => "CSV_FAIL", :name => "csv_fail"},
    'itinerary_already_booked' => {:code => "ITINERARY_ALREADY_BOOKED", :name => "itinerary_already_booked"},
    'price_mismatch' => {:code => "PRICE_MISMATCH", :name => "price_mismatch"},
    'payer_auth_failed' => {:code => "PAYER_AUTH_FAILED", :name => "payer_auth_failed"},
    'payer_auth_required' => {:code => "PAYER_AUTH_REQUIRED", :name => "payer_auth_required"},
    'res_cancelled' => {:code => "RES_CANCELLED", :name => "res_cancelled"},
    'res_not_found' => {:code => "RES_NOT_FOUND", :name => "res_not_found"}
  }

  STATUSES = {
    'CF' => {:code => 'CF', :name => "Confirmed", :description => ''},
    'CX' => {:code => 'CX', :name => "Cancelled", :description => ''},
    'UC' => {:code => 'UC', :name => "Unconfirmed", :description => "Usually due to the property being sold out. Agent will follow up. Most cases result in customer being advised to select other property when agent cannot obtain a reservation."},
    'PS' => {:code => 'PS', :name => "Pending Supplier", :description => 'Agent will follow up with customer when confirmation number is available.'},
    'ER' => {:code => 'ER', :name => "Error", :description => 'Agent attention needed. Agent will follow up.'},
    'DT' => {:code => 'DT', :name => "Deleted Itinerary", :description => '(Usually a test or failed booking.'},
    'IV' => {:code => 'IV', :name => "Invalid Status", :description => ''}
  }

  BED_TYPES={
    4 => "KING BED",
    23 => "QUEEN BED"
  }
  SMOKING_PREFERRNCES={
    "NS" => "Non-Smoking",
    "S" => "Smoking",
    "E" => "Either"
  }
  CREDIT_CARD_TYPES={
    "VI" => "Visa",
    "AX" => "American Express",
    "BC" => "BC Card",
    "CA" => "MasterCard",
    "CB" => "Carte Blanche",
    "CU" => "China Union Pay",
    "DS" => "Discover",
    "DC" => "Diners Club",
    "T" => "Carta Si",
    "R" => "Carte Bleue",
    "N" => "Dankort",
    "L" => "Delta",
    "E" => "Electron",
    "JC" => "Japan Credit Bureau",
    "TO" => "Maestro",
    "S" => "Switch"
  }
  ##====== PUBLIC METHODS

  ##
  #get email for testing of booking
  #Parameters::
  #Return::test email
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_test_email
    'duongdn@elarion.com'
  end

  ##
  #get full status of booking
  #Parameters::
  # (String) *status_code*: status code
  #Return::json data of full status
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_status status_code
    status = STATUSES[status_code]
    if status
      status
    else
      status = STATUSES['IV']
    end
  end

  ##
  #get name from a country code using gem Carmen
  #Parameters::
  # (String) *country_code*: countrycode
  #Return::json data of country name
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_country_name_lib country_code
    country = Carmen::Country.coded(country_code)
    if country
      country.name
    else
      "N/A"
    end
  end

  ##
  #get name from a country code using local database
  #Parameters::
  # (String) *country_code*: countrycode
  #Return::json data of country name
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_country_name country_code
    country = Country.find(
      :first,
      :conditions => ["LOWER(Code) = ?", country_code]
    )
    if country
      country.Name
    else
      "N/A"
    end
  end

  ##
  #get name from a state code using gem Carmen
  #Parameters::
  # (String) *country_code*: country code
  # (String) *state_code*: state code
  #Return::json data of state name
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_state_name_lib(country_code, state_code)
    country = Carmen::Country.coded(country_code)
    state_name = N/A
    if country
      state = country.subregions.coded(state_code)
      if state
        state_name = state.name
      end
    end
    state_name
  end

  ##
  #get name from a state code using local database
  #Parameters::
  # (String) *country_code*: country code
  # (String) *state_code*: state code
  #Return::json data of state name
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_state_name(country_code, state_code)
    states = State.find(
      :all,
      :conditions => ["LOWER(StateCode) = ?", state_code]
    )
    state_name = nil
    if states
      states.each do |state|
        if state.CountryCode == country_code
          state_name = state.StateName
          break
        end
      end
    end
    state_name
  end

  ##
  #get description from an airport code using local database
  #Parameters::
  # (String) *airport_code*: airport code
  #Return::json data of airport description
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_airport_description(airport_code)
    airport = Airport.find_all_by_LocationCode(airport_code).first
    if airport
      airport.Description
    else
      "N/A"
    end
  end

  def process_response(response, request_type)
    begin
      parsed_json = JSON.parse(response)
      ## other HTTP error codes: 403, 404,...
      if !parsed_json.instance_of? Hash
        values = {}
        values[:type] = get_type('unknown')[:name]
        values[:category] = get_category_name('unknown')
        values[:message] = strip_tags(response)
        values[:detail_message] = nil
        values[:itinerary_id] = -1
        values[:other_info] = nil
        values[:error_code] = nil
        values[:user_message] = nil

        return_errors(values)
      else

        ## error code from EAN service APIs
        error = parsed_json[request_type]["EanWsError"]
        if error.nil?
          return_success(response)
        else
          values = {}
          values[:type] = error["handling"]
          values[:category] = error["category"]
          values[:message] = error["presentationMessage"]
          values[:detail_message] = error["verboseMessage"]
          values[:itinerary_id] = error["itineraryId"]
          values[:other_info] = nil
          values[:error_code] = nil
          values[:user_message] = nil

          ## Other information for some special cases
          # COMMON ERRORS:
            # Search errors: no additional information
            # Credit card errors: no additional information
            # Reservation errors: no additional information
          if get_type(values[:type]) == TYPES["unrecoverable"]
            # Cancellation errors:
            if get_category_name(values[:category]) == get_category_name("unknown")
              values[:other_info] = parsed_json["ErrorAttributes"]
              values[:error_code] = t('label.error_code.invalid_confimation_number')
            end
            # Direct Connect Errors: no additional information

          # SPECIAL ERRORS:
            # Prevent Duplicate Bookings errrors: no additional information
          elsif get_type(values[:type]) == TYPES["recoverable"]
            # Price Change errors:
            if get_category_name(values[:category]) == get_category_name("price_mismatch")
              values[:other_info] = parsed_json["ErrorAttributes"]
              values[:error_code] = t('label.error_code.price_mismatch')
            elsif get_category_name(values[:category]) == get_category_name("data_validation")
              if !parsed_json[request_type]["LocationInfos"].nil?
                values[:other_info] = parsed_json[request_type]["LocationInfos"]["LocationInfo"]
                values[:error_code] = t('label.error_code.multiple_locations')
                values[:user_message] = t('message.multiple_locations')
              end
            end

          elsif get_type(values[:type]) == TYPES["agent_attention"]
            # Pending Stack Trace error:
            if get_category_name(values[:category]) == get_category_name('unknown')
              values[:other_info] = "Please wait for an agent to follow up on the final status of the booking"
              values[:error_code] = t('label.error_code.confirmed_booking')
            # Pending Process error:
            elsif get_category_name(values[:category]) == get_category_name('supplier_communication')
              values[:error_code] = t('label.error_code.pending_process')
            # Location error:
            end
          # FORCE A BOOKING ERROR
          # see HotelService::set_booking

          end # END if get_type(values[:type]) == TYPES["unrecoverable"]

          return_errors(values)
        end # END if error.nil?
      end # END if parsed_json.kind_of? Hash

    rescue ParserError # catch other HTTP error codes: 403, 404,...
      values = {}
      values[:type] = get_type('unknown')[:name]
      values[:category] = get_category_name('unknown')
      values[:message] = strip_tags(response)
      values[:detail_message] = nil
      values[:itinerary_id] = -1
      values[:other_info] = nil
      values[:error_code] = nil

      return_errors(values)
    end
  end


  ##====== PRIVATE METHODS
  private

  ##
  #get full data of type
  #Parameters::
  # (String) *type*: type code
  #Return::json data of type
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_type(type)
    TYPES[type.downcase]
  end

  ##
  #get full data of category
  #Parameters::
  # (String) *category*: category
  #Return::json data of category
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_category(category)
    CATEGORIES[category.downcase]
  end

  ##
  #get bed type
  #Parameters::
  # (String) *category*: bed type
  #Return::json data of bed type
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_bed_type(bed_type)
    BED_TYPES[bed_type]
  end

  ##
  #get smoking
  #Parameters::
  # (String) *category*: smoking
  #Return::json data of smoking
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_smoking_pre(smoking_pre)
    SMOKING_PREFERRNCES[smoking_pre].to_s
  end

  ##
  #get smoking
  #Parameters::
  # (String) *category*: smoking
  #Return::json data of smoking
  #*Author*::KhoiPCQ
  #----------------------------------------------------------------------------
  def get_credit_card(credit_card)
    CREDIT_CARD_TYPES[credit_card]
  end

  #get full code of category
  #Parameters::
  # (String) *category*: category
  #Return::json data of category code
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_category_code(category)
    cat = get_category(category)
    cat.nil? ? nil : cat[:code]
  end

  ##
  #get full name of category
  #Parameters::
  # (String) *category*: category
  #Return::json data of category name
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def get_category_name(category)
    cat = get_category(category)
    cat.nil? ? nil : cat[:name]
  end

  #return success json data
  #Parameters::
  # (Hash) *response*: response from EAN service
  #Return::json data of response with status 'OK'
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def return_success(response)
    {
      'status' => OK,
      'response' => response
    }
  end

  ##
  #return error json data
  #Parameters::
  # (Hash) *values*: error response from EAN service
  #Return::json data of response with status 'NOT OK'
  #*Author*::LongPH
  #----------------------------------------------------------------------------
  def return_errors(values)
    error = {
      'type' => values[:type],
      'category' => values[:category],
      'message' => values[:message],
      'detail_message' => values[:detail_message],
      'itinerary_id' => values[:itinerary_id],
      'other_info' => values[:other_info],
      'error_code' => values[:error_code],
      'user_message' => values[:user_message]
    }
p error
    {
      'status' => NOK,
      'error' => error
    }
  end

end
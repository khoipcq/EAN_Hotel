# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130122043321) do

  create_table "active_property_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.integer  "SequenceNumber"
    t.string   "Name"
    t.string   "Address1"
    t.string   "Address2"
    t.string   "City"
    t.string   "StateProvince"
    t.string   "PostalCode"
    t.string   "Country"
    t.float    "Latitude"
    t.float    "Longitude"
    t.string   "AirportCode"
    t.integer  "PropertyCategory"
    t.string   "PropertyCurrency"
    t.float    "StarRating"
    t.integer  "Confidence"
    t.string   "SupplierType"
    t.string   "Location"
    t.string   "ChainCodeID"
    t.integer  "RegionID"
    t.float    "HighRate"
    t.float    "LowRate"
    t.string   "CheckInTime"
    t.string   "CheckOutTime"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "active_property_lists", ["EANHotelID"], :name => "index_active_property_lists_on_EANHotelID"
  add_index "active_property_lists", ["RegionID"], :name => "index_active_property_lists_on_RegionID"

  create_table "airport_coordinates_lists", :force => true do |t|
    t.integer  "AirportID"
    t.string   "AirportCode"
    t.string   "AirportName"
    t.float    "Latitude"
    t.float    "Longitude"
    t.integer  "MainCityID"
    t.string   "CountryCode"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "airport_coordinates_lists", ["AirportID"], :name => "index_airport_coordinates_lists_on_AirportID"
  add_index "airport_coordinates_lists", ["MainCityID"], :name => "index_airport_coordinates_lists_on_MainCityID"

  create_table "airports", :force => true do |t|
    t.string   "LocationCode"
    t.string   "City"
    t.string   "StateProvince"
    t.string   "Country"
    t.string   "Description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "area_attraction_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "AreaAttractions"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "attribute_lists", :force => true do |t|
    t.integer  "AttributeID"
    t.string   "LanguageCode"
    t.text     "AttributeDesc"
    t.string   "Type"
    t.string   "SubType"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chain_lists", :force => true do |t|
    t.integer  "ChainCodeID"
    t.string   "ChainName"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "city_coordinates_lists", :force => true do |t|
    t.integer  "RegionID"
    t.text     "RegionName"
    t.text     "Coordinates"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "city_coordinates_lists", ["RegionID"], :name => "index_city_coordinates_lists_on_RegionID"

  create_table "countries", :force => true do |t|
    t.string   "Code"
    t.string   "Name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "country_lists", :force => true do |t|
    t.integer  "CountryID"
    t.string   "LanguageCode"
    t.string   "CountryName"
    t.string   "CountryCode"
    t.string   "Transliteration"
    t.integer  "ContinentID"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "country_lists", ["ContinentID"], :name => "index_country_lists_on_ContinentID"
  add_index "country_lists", ["CountryID"], :name => "index_country_lists_on_CountryID"

  create_table "currencies", :force => true do |t|
    t.string   "CurrencyCode"
    t.string   "CurrencyDescription"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "destination_ids", :force => true do |t|
    t.text     "Destination"
    t.integer  "DestinationID"
    t.float    "CenterLongitude"
    t.float    "CenterLatitude"
    t.string   "StateProvince"
    t.string   "Country"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "dining_descriptions_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "DiningDescription"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "gds_attribute_lists", :force => true do |t|
    t.integer  "AttributeID"
    t.string   "LanguageCode"
    t.text     "AttributeDesc"
    t.string   "Type"
    t.string   "SubType"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "gds_property_attribute_links", :force => true do |t|
    t.integer  "EANHotelID"
    t.integer  "AttributeID"
    t.string   "LanguageCode"
    t.text     "AttributeTxt"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "AppendTxt"
  end

  create_table "hotel_descriptions", :force => true do |t|
    t.integer  "HotelID"
    t.text     "PropertyDescription"
    t.string   "GDSChainCode"
    t.string   "GDSChaincodeName"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "hotel_image_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "Caption"
    t.text     "URL"
    t.integer  "Width"
    t.integer  "Height"
    t.integer  "ByteSize"
    t.text     "ThumbnailURL"
    t.integer  "DefaultImage"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "hotel_tests", :force => true do |t|
    t.integer  "hotelID"
    t.string   "name"
    t.string   "airportCode"
    t.text     "address1"
    t.text     "address2"
    t.text     "address3"
    t.string   "city"
    t.string   "stateProvince"
    t.string   "country"
    t.string   "postalCode"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "lowRate"
    t.string   "highRate"
    t.string   "confidence"
    t.integer  "marketingLevel"
    t.datetime "hotelModified"
    t.integer  "propertyType"
    t.text     "propertyDescription"
    t.string   "timeZone"
    t.string   "gMTOffset"
    t.string   "yearPropertyOpened"
    t.string   "yearPropertyRenovated"
    t.string   "nativeCurrency"
    t.integer  "numberOfRooms"
    t.integer  "numberOfSuites"
    t.integer  "numberOfFloors"
    t.string   "checkInTime"
    t.string   "checkOutTime"
    t.string   "hasValetParking"
    t.string   "hasContinentalBreakfast"
    t.string   "hasInRoomMovies"
    t.string   "hasSauna"
    t.string   "hasWhirlpool"
    t.string   "hasVoiceMail"
    t.string   "has24HourSecurity"
    t.string   "hasParkingGarage"
    t.string   "hasElectronicRoomKeys"
    t.string   "hasCoffeeTeaMaker"
    t.string   "hasSafe"
    t.string   "hasVideoCheckOut"
    t.string   "hasRestrictedAccess"
    t.string   "hasInteriorRoomEntrance"
    t.string   "hasExteriorRoomEntrance"
    t.string   "hasCombination"
    t.string   "hasFitnessFacility"
    t.string   "hasGameRoom"
    t.string   "hasTennisCourt"
    t.string   "hasGolfCourse"
    t.string   "hasInHouseDining"
    t.string   "hasInHouseBar"
    t.string   "hasHandicapAccessible"
    t.string   "hasChildrenAllowed"
    t.string   "hasPetsAllowed"
    t.string   "hasTVInRoom"
    t.string   "hasDataPorts"
    t.string   "hasMeetingRooms"
    t.string   "hasBusinessCenter"
    t.string   "hasDryCleaning"
    t.string   "hasIndoorPool"
    t.string   "hasOutdoorPool"
    t.string   "hasNonSmokingRooms"
    t.string   "hasAirportTransportation"
    t.string   "hasAirConditioning"
    t.string   "hasClothingIron"
    t.string   "hasWakeUpService"
    t.string   "hasMiniBarInRoom"
    t.string   "hasRoomService"
    t.string   "hasHairDryer"
    t.string   "hasCarRentDesk"
    t.string   "hasFamilyRooms"
    t.string   "hasKitchen"
    t.string   "hasMap"
    t.float    "starRating"
    t.string   "gDSChainCode"
    t.string   "gDSChaincodeName"
    t.string   "destinationID"
    t.text     "drivingDirections"
    t.text     "nearbyAttractions"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "landmark_destinations", :force => true do |t|
    t.integer  "DestinationID"
    t.text     "Name"
    t.text     "City"
    t.string   "StateProvince"
    t.string   "Country"
    t.float    "CenterLatitude"
    t.float    "CenterLongitude"
    t.integer  "Type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "neighborhood_coordinates_lists", :force => true do |t|
    t.integer  "RegionID"
    t.text     "RegionName"
    t.text     "Coordinates"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "neighborhood_coordinates_lists", ["RegionID"], :name => "index_neighborhood_coordinates_lists_on_RegionID"

  create_table "parent_region_lists", :force => true do |t|
    t.integer  "RegionID"
    t.string   "RegionType"
    t.string   "RelativeSignificance"
    t.string   "SubClass"
    t.string   "RegionName"
    t.string   "RegionNameLong"
    t.integer  "ParentRegionID"
    t.string   "ParentRegionType"
    t.string   "ParentRegionName"
    t.string   "ParentRegionNameLong"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "parent_region_lists", ["ParentRegionID"], :name => "index_parent_region_lists_on_ParentRegionID"
  add_index "parent_region_lists", ["RegionID"], :name => "index_parent_region_lists_on_RegionID"

  create_table "points_of_interest_coordinates_lists", :force => true do |t|
    t.integer  "RegionID"
    t.string   "RegionName"
    t.string   "RegionNameLong"
    t.float    "Latitude"
    t.float    "Longitude"
    t.string   "SubClassification"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "points_of_interest_coordinates_lists", ["RegionID"], :name => "index_points_of_interest_coordinates_lists_on_RegionID"

  create_table "policy_description_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "PolicyDescription"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "property_amenities", :force => true do |t|
    t.integer  "PropertyAmenityID"
    t.integer  "PropertyID"
    t.text     "Amenity"
    t.string   "AmenityMask"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "property_attribute_links", :force => true do |t|
    t.integer  "EANHotelID"
    t.integer  "AttributeID"
    t.string   "LanguageCode"
    t.text     "AppendTxt"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "property_description_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "PropertyDescription"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "property_room_types", :force => true do |t|
    t.integer  "PropertyID"
    t.string   "RoomCode"
    t.text     "RoomDescription"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "property_theme_data", :force => true do |t|
    t.integer  "PropertyID"
    t.string   "PropertyName"
    t.string   "City"
    t.string   "CountryCode"
    t.integer  "ThemeID"
    t.string   "ThemeName"
    t.string   "Supplier"
    t.string   "PropertyStatus"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "property_type_lists", :force => true do |t|
    t.integer  "PropertyCategory"
    t.string   "LanguageCode"
    t.text     "PropertyCategoryDesc"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "recreation_description_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "RecreationDescription"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "region_center_coordinates_lists", :force => true do |t|
    t.integer  "RegionID"
    t.string   "RegionName"
    t.float    "CenterLatitude"
    t.float    "CenterLongitude"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "region_center_coordinates_lists", ["RegionID"], :name => "index_region_center_coordinates_lists_on_RegionID"

  create_table "region_ean_hotel_id_mappings", :force => true do |t|
    t.integer  "RegionID"
    t.integer  "EANHotelID"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string  "title"
    t.integer "user_id"
  end

  create_table "room_type_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.integer  "RoomTypeID"
    t.string   "LanguageCode"
    t.text     "RoomTypeImage"
    t.string   "RoomTypeName"
    t.text     "RoomTypeDescription"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "spa_description_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "SpaDescription"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "star_ratings", :force => true do |t|
    t.integer  "HotelID"
    t.string   "PropertyRating"
    t.string   "PropertyName"
    t.string   "Address1"
    t.string   "Address2"
    t.string   "Address3"
    t.string   "City"
    t.string   "StateProvince"
    t.string   "Country"
    t.string   "MarketingLevel"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "states", :force => true do |t|
    t.string   "StateCode"
    t.string   "StateName"
    t.string   "CountryCode"
    t.string   "CountryName"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "user2s", :force => true do |t|
    t.string   "username"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "membership",      :default => "Normal"
    t.string   "status",          :default => "Active"
    t.string   "sex",             :default => "Male"
    t.string   "filename"
    t.string   "email",           :default => "longph@elarion.com"
    t.string   "phone"
    t.string   "title"
    t.integer  "role_id"
    t.datetime "expired_on"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
  end

  add_index "user2s", ["username", "status", "membership"], :name => "index_user2s_on_username_and_status_and_membership"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "active",                 :default => true
    t.string   "role",                   :default => "user"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "gender",                 :default => "m"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "what_to_expect_lists", :force => true do |t|
    t.integer  "EANHotelID"
    t.string   "LanguageCode"
    t.text     "WhatToExpect"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end

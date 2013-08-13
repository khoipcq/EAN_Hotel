#lib/tasks/import.rake
require 'open-uri'
require 'zip/zip'
require 'thread'

OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

## HotelTest
#rails generate model HotelTest HotelID:integer Name:string AirportCode:string Address1:text Address2:text Address3:text City:string StateProvince:string Country:string PostalCode:string Longitude:float Latitude:float LowRate:string HighRate:string Confidence:string MarketingLevel:integer HotelModified:datetime PropertyType:integer PropertyDescription:text TimeZone:string GMTOffset:string YearPropertyOpened:string YearPropertyRenovated:string NativeCurrency:string NumberOfRooms:integer NumberOfSuites:integer NumberOfFloors:integer CheckInTime:string CheckOutTime:string HasValetParking:string HasContinentalBreakfast:string HasInRoomMovies:string HasSauna:string HasWhirlpool:string HasVoiceMail:string Has24HourSecurity:string HasParkingGarage:string HasElectronicRoomKeys:string HasCoffeeTeaMaker:string HasSafeLstring HasVideoCheckOut:string HasRestrictedAccess:string HasInteriorRoomEntrance:string HasExteriorRoomEntrance:string HasCombination:string  HasFItnessFacility:string HasGameRoom:string HasTennisCourt:string HasGolfCourse:string HasInHouseDining:string HasInHouseBar:string HasHandicapAccessible:string HasChildrenAllowed:string HasPetsAllowed:string HasTVInRoom:string HasDataPorts:string HasMeetingRooms:string HasBusinessCenter:string HasDryCleaning:string HasIndoorPool:string HasOutdoorPool HasNonSmokingRooms:string HasAirportTransportation:string HasAirConditioning:string HasClothingIron:string HasWakeUpService:string HasMiniBarInRoom:string HasRoomService:string HasHairDryer:string HasCarRentDesk:string HasFamilyRooms:string HasKitchen:string HasMap:string StarRating:float GDSChainCode:string FDSChaincodeName:string DestinationID:string DrivingDirections:text NearbyAttractions:text

##$$ Geography Data
## ActivePropertyList
#rails generate model ActivePropertyList EANHotelID:integer SequenceNumber:integer Name:string Address1:string Address2:string City:string StateProvince:string PostalCode:string Country:string Latitude:float Longitude:float AirportCode:string PropertyCategory:integer PropertyCurrency:string StarRating:float Confidence:integer SupplierType:string Location:string ChainCodeID:string RegionID:integer HighRate:float LowRate:float CheckInTime:string CheckOutTime:string
## CityCoordinatesList
#rails generate model CityCoordinatesList RegionID:integer RegionName:text Coordinates:text
## AirportCoordinatesList
#rails generate model AirportCoordinatesList AirportID:integer AirportCode:string AirportName:string Latitude:float Longitude:float MainCityID:integer CountryCode:string
## CountryList
#rails generate model CountryList CountryID:integer LanguageCode:string CountryName:string CountryCode:string Transliteration:string ContinentID:integer
## ParentRegionList
#rails generate model ParentRegionList RegionID:integer RegionType:string RelativeSignificance:string SubClass:string RegionName:string RegionNameLong:string ParentRegionID:integer ParentRegionType:string ParentRegionName:string ParentRegionNameLong:string
## NeighborhoodCoordinatesList
#rails generate model NeighborhoodCoordinatesList RegionID:integer RegionName:string Coordinates:text
## PointsOfInterestCoordinatesList
#rails generate model PointsOfInterestCoordinatesList RegionID:integer RegionName:string RegionNameLong:string Latitude:float Longitude:float SubClassification:string
## RegionCenterCoordinatesList
#rails generate model RegionCenterCoordinatesList RegionID:integer RegionName:string CenterLatitude:float CenterLongitude:float
## RegionEANHotelIDMapping
#rails generate model RegionEANHotelIDMapping RegionID:integer EANHotelID:integer

##$$ Property Data
## ChainList
#rails generate model ChainList ChainCodeID:integer ChainName:string
## PropertyTypeList
#rails generate model PropertyTypeList PropertyCategory:integer LanguageCode:string PropertyCategoryDesc:text
## PropertyDescriptionList
#rails generate model PropertyDescriptionList EANHotelID:integer LanguageCode:string PropertyDescription:text
## RecreationDescriptionList
#rails generate model RecreationDescriptionList EANHotelID:integer LanguageCode:string RecreationDescription:text
## PolicyDescriptionList
#rails generate model PolicyDescriptionList EANHotelID:integer LanguageCode:string PolicyDescription:text
## AreaAttractionList
#rails generate model AreaAttractionList EANHotelID:integer LanguageCode:string AreaAttractions:text
## WhatToExpectList
#rails generate model WhatToExpectList EANHotelID:integer LanguageCode:string WhatToExpect:text
## SpaDescriptionList
#rails generate model SpaDescriptionList EANHotelID:integer LanguageCode:string SpaDescription:text
## DiningDescriptionsList
#rails generate model DiningDescriptionsList EANHotelID:integer LanguageCode:string DiningDescription:text

##$$ Room Type Data
## RoomTypeList
#rails generate model RoomTypeList EANHotelID:integer RoomTypeID:integer LanguageCode:string RoomTypeImage:text RoomTypeName:string RoomTypeDescription:text

##$$ Amenity & Policy Data
## AttributeList
#rails generate model AttributeList AttributeID:integer LanguageCode:string AttributeDesc:text Type:string SubType:string
## PropertyAttributeLink
#rails generate model PropertyAttributeLink EANHotelID:integer AttributeID:integer LanguageCode:string AppendTxt:text
## GDSAttributeList
#rails generate model GDSAttributeList AttributeID:integer LanguageCode:string AttributeDesc:text Type:string SubType:string
## GDSPropertyAttributeLink
#rails generate model GDSPropertyAttributeLink EANHotelID:integer AttributeID:integer LanguageCode:string AttributeTxt:text

##$$ Image Data
## HotelImageList
#rails generate model HotelImageList EANHotelID:integer Caption:string URL:text Width:integer Height:integer ByteSize:integer ThumbnailURL:text DefaultImage:integer

##$$ Hotel Details
## PropertyAmenity
#rails generate model PropertyAmenity PropertyAmenityID:integer PropertyID:integer Amenity:text AmenityMask:string
## HotelDescription
#rails generate model HotelDescription HotelID:integer PropertyDescription:text GDSChainCode:string GDSChaincodeName:string

##$$ Special Content Files
## StarRating
#rails generate model StarRating HotelID:integer PropertyRating:string PropertyName:string Address1:string Address2:string Address3:string City:string StateProvince:string Country:string MarketingLevel:string
## LandmarkDestination
#rails generate model LandmarkDestination DestinationID:integer Name:text City:text StateProvince:string Country:string CenterLatitude:float CenterLongitude:float Type:integer
## PropertyRoomType
#rails generate model PropertyRoomType PropertyID:integer RoomCode:string RoomDescription:text
## Destination ID
#rails generate model DestinationID Destination:text DestinationID:integer CenterLongitude:float CenterLatitude:float StateProvince:string CountryList:string
## CountryCode
#rails generate model Country Code:string Name:string
## StateCode
#rails generate model State StateCode:string StateName:string CountryCode:string CountryName:string
## CurrencyCode
#rails generate model Currency CurrencyCode:string CurrencyDescription:string
## PropertyThemeData
#rails generate model PropertyThemeData PropertyID:integer PropertyName:string City:string CountryCode:string ThemeID:integer ThemeName:string Supplier:string PropertyStatus:string


## Update remote data
#rake update_remote_data[CountryList,true] RAILS_ENV=production
#rake update_remote_data[AirportCoordinatesList,true] RAILS_ENV=production
#rake update_remote_data[CityCoordinatesList,true] RAILS_ENV=production
#rake update_remote_data[NeighborhoodCoordinatesList,true] RAILS_ENV=production
#rake update_remote_data[ParentRegionList,true] RAILS_ENV=production
#rake update_remote_data[PointsOfInterestCoordinatesList,true] RAILS_ENV=production
#rake update_remote_data[RegionCenterCoordinatesList,true] RAILS_ENV=production
#rake update_remote_data[RegionEANHotelIDMapping,true] RAILS_ENV=production
#rake update_remote_data[ActivePropertyList,true] RAILS_ENV=production


## Performance:
#Hotels with 765 records => 17.7 (s)
#Hotels with 9326 records => 200.5 (s)
#Hotels with 106226 records => 2273.5 (s)
#Hotels with 106226 records in archive => 2442.7 (s)

desc "Imports a file into an ActiveRecord table"
task :csv_model_import, [:filename, :model, :delete, :archive_file] => :environment do |task,args|
  p "=========================="
  puts "=== BEGIN: Imports a file into an ActiveRecord table".colorize(:color => :red)
  p "=== " + args.to_s
  p "=========================="

  ## Initialize
  line_count = 1
  time_start = Time.now
  p "=== Time start: #{time_start.to_s}"

  ## delete all if needed
  #if (args[:delete] == true || args[:delete] == 'true')
    p "=== BEGIN: Clear old data"
    Module.const_get(args[:model]).delete_all
    p "=== FINISH: Clear old data"
  #end

  ## read from archives
  if (args[:archive_file] != nil)
    lines = Zip::ZipFile.new(args[:filename]).read(args[:archive_file]).split("\n")
  else
    lines = File.new(args[:filename]).readlines
  end

  ## begin importing
  p "=== BEGIN: Import data"
  header = lines.shift.strip
  ## rename attributes to lowercase to match with services
  if header.index("\xEF\xBB\xBF") # file in UTF-8 format
    p "oops! This is an UTF-8 file with Byte-Of-Mask"
    header.sub!(/^\xEF\xBB\xBF/, '')
  end
  keys = header.split('|')
  # new_keys = []
  # keys.each do |attribute|
  #   attribute = attribute.uncapitalize
  #   new_keys << attribute
  # end
  # keys = new_keys

  temp_array = []
  lines.each do |line|
    begin
      # line = line.unpack('C*').pack('U*') if !line.valid_encoding?
      # line = line.encode('utf-8', 'iso-8859-1')
      # values = line.strip.split('|')
      # attributes = Hash[keys.zip values]
      # Module.const_get(args[:model]).create(attributes)
      # line_count = line_count + 1
      # p "-----Finish: #{line_count} lines" if (line_count % 500) == 0

      if (line_count % 10000) != 0
        line = line.unpack('C*').pack('U*') if !line.valid_encoding?
        line = line.encode('utf-8', 'iso-8859-1')
        values = line.strip.split('|')
        attributes = Hash[keys.zip values]
        object = Module.const_get(args[:model]).new(attributes)
        temp_array << object
      else
        Module.const_get(args[:model]).transaction do
          temp_array.each do |obj|
            status = obj.save
          end
        end
        temp_array = []
        p "-----Finish: #{line_count} lines"
      end
      line_count = line_count + 1
    rescue => exception
      #p line
      p exception
    end
  end

  if temp_array.size > 0
    Module.const_get(args[:model]).transaction do
      temp_array.each do |obj|
        status = obj.save
      end
    end
    temp_array = []
    p "-----Finish: #{line_count} lines"
  end

  p "=========================="
  p "FINISH: Imports a file into an ActiveRecord table"
  p "=== " + args.to_s
  p "=== Lines have been imported: #{line_count}"
  p "=== Time spent: #{Time.now - time_start} (s)"
  p "=========================="
end

desc "Get file from remote server and Imports into an ActiveRecord table"
task :update_remote_data, [:model, :delete] => :environment do |task, args|

  p "=========================="
  p "=== BEGIN: Get and Imports a remote file into an ActiveRecord table"
  puts ("=== " + args.to_s).colorize(:background => :yellow)
  p "=========================="

  ## Initialize
  line_count = 0
  time_start = Time.now
  p "=== Time start: #{time_start.to_s}"

  ## delete all if needed
  if (args[:delete] == true || args[:delete] == 'true')
    p "=== BEGIN: Clear old data"
    Module.const_get(args[:model]).delete_all
    p "=== FINISH: Clear old data"
  end

  ## prepare url and files
  url = ""
  file = ""

  if args[:model] == 'CountryList'
    url = "https://www.ian.com/affiliatecenter/include/V2/CountryList.zip"
    file = "CountryList.txt"
  elsif args[:model] == 'AirportCoordinatesList'
    url = "https://www.ian.com/affiliatecenter/include/V2/AirportCoordinatesList.zip"
    file = "AirportCoordinatesList.txt"
  elsif args[:model] == 'CityCoordinatesList'
    url = "https://www.ian.com/affiliatecenter/include/V2/CityCoordinatesList.zip"
    file = "CityCoordinatesList.txt"
  elsif args[:model] == 'NeighborhoodCoordinatesList'
    url = "https://www.ian.com/affiliatecenter/include/V2/NeighborhoodCoordinatesList.zip"
    file = "NeighborhoodCoordinatesList.txt"
  elsif args[:model] == 'ParentRegionList'
    url = "https://www.ian.com/affiliatecenter/include/V2/ParentRegionList.zip"
    file = "ParentRegionList.txt"
  elsif args[:model] == 'PointsOfInterestCoordinatesList'
    url = "https://www.ian.com/affiliatecenter/include/V2/PointsOfInterestCoordinatesList.zip"
    file = "PointsOfInterestCoordinatesList.txt"
  elsif args[:model] == 'RegionCenterCoordinatesList'
    url = "https://www.ian.com/affiliatecenter/include/V2/RegionCenterCoordinatesList.zip"
    file = "RegionCenterCoordinatesList.txt"
  elsif args[:model] == 'RegionEANHotelIDMapping'
    url = "https://www.ian.com/affiliatecenter/include/V2/RegionEANHotelIDMapping.zip"
    file = "RegionEANHotelIDMapping.txt"
  elsif args[:model] == 'ActivePropertyList'
    url = "https://www.ian.com/affiliatecenter/include/V2/ActivePropertyList.zip"
    file = "ActivePropertyList.txt"
  elsif args[:model] == 'LandmarkDestination'
    url = "https://www.ian.com/affiliatecenter/include/Landmark.zip"
    file = "Landmark.txt"
  else
    return
  end

  ## download file
  #the website will drop the connection without the user-agent and other stuff.
  p "=== BEGIN: Download file #{file}"
  downloaded_file = open(url,
       "User-Agent" => "Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100402 Ubuntu/9.10 (karmic) Firefox/3.5.9",
       "From" => "foo@bar.com",
       "Referer" => "http://www.foo.bar")
  p "=== FINISH: Download file #{file}"

  ## read from archives
  #lines = downloaded_file.read(file).split("\n")
  lines = Zip::ZipFile.open(downloaded_file).read(file).split("\n")
  #p "yahoooo! I can download this zip file."

  ## begin importing
  p "=== BEGIN: Import data"
  header = lines.shift.strip
  ## rename attributes to lowercase to match with services
  if header.index("\xEF\xBB\xBF") # file in UTF-8 format
    p "oops! This is an UTF-8 file with Byte-Of-Mask"
    header.sub!(/^\xEF\xBB\xBF/, '')
  end
  keys = header.split('|')
  # new_keys = []
  # keys.each do |attribute|
  #   attribute = attribute.uncapitalize
  #   new_keys << attribute
  # end
  # keys = new_keys

  temp_array = []
  lines.each do |line|
    begin
      # line = line.unpack('C*').pack('U*') if !line.valid_encoding?
      # line = line.encode('utf-8', 'iso-8859-1')
      # values = line.strip.split('|')
      # attributes = Hash[keys.zip values]
      # Module.const_get(args[:model]).create(attributes)
      # line_count = line_count + 1
      # p "-----Finish: #{line_count} lines" if (line_count % 500) == 0

      if (line_count % 10000) != 0
        line = line.unpack('C*').pack('U*') if !line.valid_encoding?
        line = line.encode('utf-8', 'iso-8859-1')
        values = line.strip.split('|')
        attributes = Hash[keys.zip values]
        
        model = Module.const_get(args[:model])

        object = case args[:model]
          when "CountryList"
            model.find_or_create_by_CountryCode(attributes["CountryCode"]) if ttributes["CountryCode"]
          when "AirportCoordinatesList"
            model.find_or_create_by_AirportCode(attributes["AirportCode"]) if attributes["AirportCode"]
          when "CityCoordinatesList"
            model.find_or_create_by_RegionName(attributes["RegionName"]) if attributes["RegionName"]
          when "NeighborhoodCoordinatesList"
            model.find_or_create_by_RegionName(attributes["RegionName"]) if attributes["RegionName"]
          when "ParentRegionList"
            model.find_or_create_by_RegionName(attributes["RegionName"]) if attributes["RegionName"]
          when "PointsOfInterestCoordinatesList"
            model.find_or_create_by_RegionName(attributes["RegionName"]) if attributes["RegionName"]
          when "RegionCenterCoordinatesList"
            model.find_or_create_by_RegionName(attributes["RegionName"]) if attributes["RegionName"]
          when "RegionEANHotelIDMapping"
            model.find_or_create_by_RegionName_and_EANHotelID(attributes["RegionID"], attributes["EANHotelID"]) if attributes["RegionID"] && attributes["EANHotelID"]
          when "ActivePropertyList"
            model.find_or_create_by_Name(attributes["Name"]) if attributes["Name"]
          when "LandmarkDestination"
            model.find_or_create_by_Name(attributes["Name"]) if attributes["Name"]
          end

        if object
          object.update_attributes(attributes)
          temp_array << object
        end
      else
        Module.const_get(args[:model]).transaction do
          temp_array.each do |obj|
            status = obj.save
          end
        end
        temp_array = []
        p "-----Finish: #{line_count} lines"
      end
      line_count = line_count + 1
    rescue => exception
      #p line
      p exception
    end
  end

  if temp_array.size > 0
    Module.const_get(args[:model]).transaction do
      temp_array.each do |obj|
        status = obj.save
      end
    end
    temp_array = []
    p "-----Finish: #{line_count} lines"
  end

  p "=========================="
  p "=== END: Get and Imports a remote file into an ActiveRecord table"
  p "=== " + args.to_s
  p "=== Lines have been imported: #{line_count}"
  p "=== Time spent: #{Time.now - time_start} (s)"
  p "=========================="
end

## other functions
class String
  def uncapitalize
    self.gsub!(/\"/, '')#.gsub(/(?<!^|,)"(?!,|$)/, '')
    self[0, 1].downcase + self[1..-1]
  end
end

desc "Get file from remote server and Imports into an ActiveRecord table"
task :update_data do
  list = %w{CountryList AirportCoordinatesList CityCoordinatesList NeighborhoodCoordinatesList ParentRegionList 
    PointsOfInterestCoordinatesList
    RegionCenterCoordinatesList RegionEANHotelIDMapping ActivePropertyList LandmarkDestination}
  
  list.each do |item|
    Rake::Task["update_remote_data"].reenable
    Rake::Task["update_remote_data"].invoke(item)
  end
end
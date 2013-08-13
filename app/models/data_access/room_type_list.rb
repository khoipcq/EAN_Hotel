class RoomTypeList < ActiveRecord::Base
  attr_accessible :EANHotelID, :LanguageCode, :RoomTypeDescription, :RoomTypeID, :RoomTypeImage, :RoomTypeName
end

class HotelImageList < ActiveRecord::Base
  attr_accessible :ByteSize, :Caption, :DefaultImage, :EANHotelID, :Height, :ThumbnailURL, :URL, :Width
end

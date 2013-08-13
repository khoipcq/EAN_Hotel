class StarRating < ActiveRecord::Base
  attr_accessible :Address1, :Address2, :Address3, :City, :Country, :HotelID, :MarketingLevel, :PropertyName, :PropertyRating, :StateProvince
end

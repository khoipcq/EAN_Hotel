class CountryList < ActiveRecord::Base
  attr_accessible :ContinentID, :CountryCode, :CountryID, :CountryName, :LanguageCode, :Transliteration
end

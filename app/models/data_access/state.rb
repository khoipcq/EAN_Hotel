class State < ActiveRecord::Base
  ## attributes
  attr_accessible :StateCode, :StateName, :CountryCode, :CountryName

  ## associations
  has_many :get_landmarks, :class_name => "LandmarkDestination",
    :primary_key => "StateCode", :foreign_key => "StateProvince"
  has_many :get_hotels, :class_name => "ActivePropertyList",
    :primary_key => "StateCode", :foreign_key => "StateProvince"

end

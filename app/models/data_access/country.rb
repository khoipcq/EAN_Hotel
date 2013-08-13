class Country < ActiveRecord::Base
  ## attributes
  attr_accessible :Code, :Name, :Code3, :Number

  ## associations
  has_many :get_landmarks, :class_name => "LandmarkDestination",
    :primary_key => "Code3", :foreign_key => "Country"
  has_many :get_hotels, :class_name => "ActivePropertyList",
    :primary_key => "Code", :foreign_key => "Country"
end

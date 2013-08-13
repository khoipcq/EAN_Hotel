class Airport < ActiveRecord::Base
  attr_accessible :City, :Country, :Description, :LocationCode, :StateProvince
end

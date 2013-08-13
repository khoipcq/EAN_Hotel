class AirportCoordinatesList < ActiveRecord::Base
  ## attributes
  attr_accessible :AirportCode, :AirportID, :AirportName, :CountryCode, :Latitude, :Longitude, :MainCityID

  ## associations

  ## For thinking_sphinx
  define_index do
    join get_country
    ## fields: for searching
    indexes "LOWER(AirportName)"

    ## attributes: for sorting, filtering, grouping...
    has "LOWER(AirportName)", :as => :name_sort, :type => :string

    ## flag for autoupdate
    set_property :delta => true
  end

end

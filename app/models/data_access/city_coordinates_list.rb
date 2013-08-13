class CityCoordinatesList < ActiveRecord::Base
  ## attributes
  attr_accessible :Coordinates, :RegionID, :RegionName

  ## For thinking_sphinx
  define_index do
    ## fields: for searching
    indexes "LOWER(RegionName)"

    ## attributes: for sorting, filtering, grouping...
    has "LOWER(RegionName)", :as => :name_sort, :type => :string
    has "length(RegionName)", :as => :name_length, :type => :integer

    ## flag for autoupdate
    set_property :delta => true
  end
end

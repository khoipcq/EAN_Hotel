class LandmarkDestination < ActiveRecord::Base
  ## attributes
  attr_accessible :CenterLatitude, :CenterLongitude, :City, :Country, :DestinationID, :Name, :StateProvince, :Type

  ## associations
  belongs_to :get_country, :class_name => "Country", :primary_key => "Code3", :foreign_key => "Country"
  belongs_to :get_state, :class_name => "State", :primary_key => "StateCode", :foreign_key => "StateProvince"

  ## For thinking_sphinx
  define_index do
    ## fields: for searching
    indexes "LOWER(landmark_destinations.Name)"
    indexes "LOWER(landmark_destinations.City)"
    indexes get_state.StateName, :as => :state_code
    indexes get_country.Name, :as => :country_code

    ## attributes: for sorting, filtering, grouping...
    has "LOWER(landmark_destinations.Name)", :as => :name_sort, :type => :string
    has "LOWER(landmark_destinations.City)", :as => :city_sort, :type => :string

    ## flag for autoupdate
    set_property :delta => true
  end


end

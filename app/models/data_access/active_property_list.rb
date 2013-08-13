class ActivePropertyList < ActiveRecord::Base
  ## attributes
  attr_accessible :Address1, :Address2, :AirportCode, :ChainCodeID, :CheckInTime, :CheckOutTime, :City, :Confidence, :Country, :EANHotelID, :HighRate, :Latitude, :Location, :Longitude, :LowRate, :Name, :PostalCode, :PropertyCategory, :PropertyCurrency, :RegionID, :SequenceNumber, :StarRating, :StateProvince, :SupplierType

  ## associations
  belongs_to :get_country, :class_name => "Country", :primary_key => "Code", :foreign_key => "Country"
  belongs_to :get_state, :class_name => "State", :primary_key => "StateCode", :foreign_key => "StateProvince"

  ## For thinking_sphinx
  define_index do
    ## fields: for searching
    indexes "LOWER(active_property_lists.Name)"#, :sortable => :insensitive
    indexes "LOWER(active_property_lists.City)"#, :sortable => true
    indexes get_state.StateName, :as => :state_code#, :sortable => true
    indexes get_country.Name, :as => :country_code#, :sortable => true

    ## attributes: for sorting, filtering, grouping...
    has "LOWER(active_property_lists.Name)", :as => :name_sort, :type => :string
    has "LOWER(active_property_lists.City)", :as => :city_sort, :type => :string

    ## flag for autoupdate
    set_property :delta => true
  end
end

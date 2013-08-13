class AddIndexesToPropertyData < ActiveRecord::Migration
  def change
	  add_index 'country_lists', 'CountryID'
	  add_index 'country_lists', 'ContinentID'
	  add_index 'airport_coordinates_lists', 'AirportID'
	  add_index 'airport_coordinates_lists', 'MainCityID'
	  add_index 'city_coordinates_lists', 'RegionID'
	  add_index 'neighborhood_coordinates_lists', 'RegionID'
	  add_index 'parent_region_lists', 'RegionID'
	  add_index 'parent_region_lists', 'ParentRegionID'
	  add_index 'points_of_interest_coordinates_lists', 'RegionID'
	  add_index 'region_center_coordinates_lists', 'RegionID'
	  add_index 'region_ean_hotel_id_mappings', 'RegionID'
	  add_index 'region_ean_hotel_id_mappings', 'EANHotelID'
	  add_index 'active_property_lists', 'EANHotelID'
	  add_index 'active_property_lists', 'RegionID'
	end
end
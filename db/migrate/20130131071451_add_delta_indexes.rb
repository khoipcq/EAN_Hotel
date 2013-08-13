class AddDeltaIndexes < ActiveRecord::Migration
  def up
    add_column :city_coordinates_lists, :delta, :boolean, :default => true, :null => false
    add_column :landmark_destinations, :delta, :boolean, :default => true, :null => false
    add_column :airport_coordinates_lists, :delta, :boolean, :default => true, :null => false
    add_column :active_property_lists, :delta, :boolean, :default => true, :null => false
  end

  def down
    remove_column :city_coordinates_lists, :delta
    remove_column :landmark_destinations, :delta
    remove_column :airport_coordinates_lists, :delta
    remove_column :active_property_lists, :delta
  end
end

class ChangeDestinationIdOfLandmarkDestinations < ActiveRecord::Migration
  def up
    change_column :landmark_destinations, :DestinationID, :string
  end

  def down
    change_column :landmark_destinations, :DestinationID, :string
  end
end

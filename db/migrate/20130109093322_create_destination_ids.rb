class CreateDestinationIds < ActiveRecord::Migration
  def change
    create_table :destination_ids do |t|
      t.text :Destination
      t.integer :DestinationID
      t.float :CenterLongitude
      t.float :CenterLatitude
      t.string :StateProvince
      t.string :Country

      t.timestamps
    end
  end
end

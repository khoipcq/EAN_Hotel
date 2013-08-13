class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :LocationCode
      t.string :City
      t.string :StateProvince
      t.string :Country
      t.string :Description

      t.timestamps
    end
  end
end

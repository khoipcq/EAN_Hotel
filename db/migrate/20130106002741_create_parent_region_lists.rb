class CreateParentRegionLists < ActiveRecord::Migration
  def change
    create_table :parent_region_lists do |t|
      t.integer :RegionID
      t.string :RegionType
      t.string :RelativeSignificance
      t.string :SubClass
      t.string :RegionName
      t.string :RegionNameLong
      t.integer :ParentRegionID
      t.string :ParentRegionType
      t.string :ParentRegionName
      t.string :ParentRegionNameLong

      t.timestamps
    end
  end
end

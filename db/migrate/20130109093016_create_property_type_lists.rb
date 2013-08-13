class CreatePropertyTypeLists < ActiveRecord::Migration
  def change
    create_table :property_type_lists do |t|
      t.integer :PropertyCategory
      t.string :LanguageCode
      t.text :PropertyCategoryDesc

      t.timestamps
    end
  end
end

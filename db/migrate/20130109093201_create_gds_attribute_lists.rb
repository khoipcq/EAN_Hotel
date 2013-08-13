class CreateGdsAttributeLists < ActiveRecord::Migration
  def change
    create_table :gds_attribute_lists do |t|
      t.integer :AttributeID
      t.string :LanguageCode
      t.text :AttributeDesc
      t.string :Type
      t.string :SubType

      t.timestamps
    end
  end
end

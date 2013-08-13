class CreateGdsPropertyAttributeLinks < ActiveRecord::Migration
  def change
    create_table :gds_property_attribute_links do |t|
      t.integer :EANHotelID
      t.integer :AttributeID
      t.string :LanguageCode
      t.text :AttributeTxt
      t.text :AppendTxt

      t.timestamps
    end
  end
end

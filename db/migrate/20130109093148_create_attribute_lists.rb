class CreateAttributeLists < ActiveRecord::Migration
  def change
    create_table :attribute_lists do |t|
      t.integer :AttributeID
      t.string :LanguageCode
      t.text :AttributeDesc
      t.string :Type
      t.string :SubType

      t.timestamps
    end
  end
end

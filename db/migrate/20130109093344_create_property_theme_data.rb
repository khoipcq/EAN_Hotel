class CreatePropertyThemeData < ActiveRecord::Migration
  def change
    create_table :property_theme_data do |t|
      t.integer :PropertyID
      t.string :PropertyName
      t.string :City
      t.string :CountryCode
      t.integer :ThemeID
      t.string :ThemeName
      t.string :Supplier
      t.string :PropertyStatus

      t.timestamps
    end
  end
end

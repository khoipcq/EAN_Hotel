class CreateHotelImageLists < ActiveRecord::Migration
  def change
    create_table :hotel_image_lists do |t|
      t.integer :EANHotelID
      t.string :Caption
      t.text :URL
      t.integer :Width
      t.integer :Height
      t.integer :ByteSize
      t.text :ThumbnailURL
      t.integer :DefaultImage

      t.timestamps
    end
  end
end

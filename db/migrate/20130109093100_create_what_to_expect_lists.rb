class CreateWhatToExpectLists < ActiveRecord::Migration
  def change
    create_table :what_to_expect_lists do |t|
      t.integer :EANHotelID
      t.string :LanguageCode
      t.text :WhatToExpect

      t.timestamps
    end
  end
end

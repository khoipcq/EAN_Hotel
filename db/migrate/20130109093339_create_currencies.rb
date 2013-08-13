class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :CurrencyCode
      t.string :CurrencyDescription

      t.timestamps
    end
  end
end

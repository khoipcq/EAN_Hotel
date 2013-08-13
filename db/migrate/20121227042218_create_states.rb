class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :StateCode
      t.string :StateName
      t.string :CountryCode
      t.string :CountryName

      t.timestamps
    end
  end
end

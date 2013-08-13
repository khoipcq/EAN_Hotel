class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :Code
      t.string :Name

      t.timestamps
    end
  end
end

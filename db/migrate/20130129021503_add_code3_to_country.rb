class AddCode3ToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :Code3, :string, :default => ''
    add_column :countries, :Number, :string, :default => ''
  end
end


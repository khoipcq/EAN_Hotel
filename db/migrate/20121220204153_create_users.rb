class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :user2s do |t|
      t.string :username
      t.string :hashed_password
      t.string :salt
      t.string :first_name
      t.string :last_name
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :membership, :default => "Normal"
      t.string :status, :default => "Active"
      t.string :sex, :default => "Male"
      t.string :filename
      t.string :email, :default => "longph@elarion.com"
      t.string :phone
      t.string :title
      t.integer :role_id
      t.datetime :expired_on

      t.timestamps
    end

      # add some indexes
      add_index :user2s, [:username, :status, :membership]

  end

  def self.down
    drop_table :user2s
  end
end

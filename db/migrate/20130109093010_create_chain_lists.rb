class CreateChainLists < ActiveRecord::Migration
  def change
    create_table :chain_lists do |t|
      t.integer :ChainCodeID
      t.string :ChainName

      t.timestamps
    end
  end
end

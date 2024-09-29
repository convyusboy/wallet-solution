class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :amount
      t.integer :owner_id

      t.timestamps
    end
  end
end

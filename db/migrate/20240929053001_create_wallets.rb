class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.integer :amount, default: 0
      t.integer :owner_id
      t.string :wallet_type

      t.timestamps
    end
  end
end

class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :trx_type
      t.integer :amount
      t.integer :to_wallet_id
      t.integer :from_wallet_id

      t.timestamps
    end
  end
end

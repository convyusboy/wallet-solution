class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.integer :amount
      t.integer :owner_id
      t.integer :price

      t.timestamps
    end
  end
end

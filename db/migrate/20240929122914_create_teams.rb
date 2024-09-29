class CreateTeams < ActiveRecord::Migration[7.2]
  def change
    create_table :teams do |t|
      t.integer :leader_id
      t.string :name

      t.timestamps
    end
  end
end

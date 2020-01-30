class CreateLocks < ActiveRecord::Migration[5.2]
  def change
    create_table :locks do |t|
      t.integer :scooter_id
      t.datetime :unlocked_at

      t.timestamps
    end
    add_index :locks, :scooter_id
  end
end

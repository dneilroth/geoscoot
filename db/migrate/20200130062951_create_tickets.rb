class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer :scooter_id
      t.datetime :completed_at
      t.string :description

      t.timestamps
    end
    add_index :tickets, :scooter_id
    add_index :tickets, :completed_at
  end
end

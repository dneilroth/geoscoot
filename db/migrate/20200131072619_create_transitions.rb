class CreateTransitions < ActiveRecord::Migration[5.2]
  def change
    create_table :transitions do |t|
      t.string :from
      t.string :to
      t.string :event
      t.integer :battery
      t.st_point :lonlat, geographic: true
      t.references :scooter, null: false

      t.timestamps
    end
  end
end

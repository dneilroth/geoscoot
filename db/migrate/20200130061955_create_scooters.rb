class CreateScooters < ActiveRecord::Migration[5.2]
  def change
    create_table :scooters do |t|
      t.string :state
      t.integer :battery
      t.st_point :lonlat, geographic: true

      t.timestamps
    end
    add_index :scooters, :state
  end
end

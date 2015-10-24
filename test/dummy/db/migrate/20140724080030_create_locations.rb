class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :test_country
      t.string :test_state

      t.timestamps
    end
  end
end

class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :country
      t.string :state
      t.string :city

      t.timestamps
    end
  end
end

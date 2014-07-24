class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :country_id
      t.integer :state_id

      t.timestamps
    end
  end
end

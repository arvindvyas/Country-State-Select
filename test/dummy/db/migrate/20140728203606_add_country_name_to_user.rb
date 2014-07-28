class AddCountryNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :country_name, :string
  end
end

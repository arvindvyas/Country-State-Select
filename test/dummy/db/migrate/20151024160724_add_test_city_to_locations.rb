class AddTestCityToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :test_city, :string
  end
end

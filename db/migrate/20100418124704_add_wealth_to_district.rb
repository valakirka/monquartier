class AddWealthToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :wealth, :integer
    add_column :districts, :wealth_points, :integer
  end

  def self.down
    remove_column :districts, :wealth_points
    remove_column :districts, :wealth
  end
end

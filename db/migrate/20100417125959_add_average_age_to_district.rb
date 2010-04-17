class AddAverageAgeToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :age, :integer
    add_column :districts, :age_points, :integer
  end

  def self.down
    remove_column :districts, :age_points
    remove_column :districts, :age
  end
end

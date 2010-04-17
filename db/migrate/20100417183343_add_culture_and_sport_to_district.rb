class AddCultureAndSportToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :culture_and_sport, :integer
    add_column :districts, :culture_and_sport_points, :integer
  end

  def self.down
    remove_column :districts, :culture_and_sport
    remove_column :districts, :culture_and_sport_points
  end
end

class AddPopulationToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :population, :integer
  end

  def self.down
    remove_column :districts, :population
  end
end

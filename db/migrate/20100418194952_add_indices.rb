class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :cities, :nicename
    add_index :districts, [:city_id, :nicename]
  end

  def self.down
    remove_index :districts, [:city_id, :nicename]
    remove_index :cities, :nicename
  end
end

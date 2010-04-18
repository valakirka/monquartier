class AddCoordinatesToDistrict < ActiveRecord::Migration
  def self.up
    add_column :districts, :coordinates, :string
  end

  def self.down
    remove_column :districts, :coordinates
  end
end

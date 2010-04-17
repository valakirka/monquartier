class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.integer :city_id
      t.string :ine_id
      t.string :name
      t.string :nicename

      t.timestamps
    end
  end

  def self.down
    drop_table :districts
  end
end

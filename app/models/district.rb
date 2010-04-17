class District < ActiveRecord::Base
  belongs_to :city
  
  def self.normalize!
    max_age = District.maximum(:age)
    min_age = District.minimum(:age)
    all.each do |district|
      district.update_attributes!(:age_points => ((district.age - min_age) * (5.0 / (max_age - min_age)) * 100).to_i)
    end
  end
end

class District < ActiveRecord::Base
  belongs_to :city
  
  def self.normalize!
    City.all(:include => :districts).each do |city|
      max_age = city.districts.maximum(:age)
      min_age = city.districts.minimum(:age)
      city.districts.each do |district|
        age_points = if city.districts.one?
          250
        else
          district.update_attributes!(:age_points => ((district.age - min_age) * (5.0 / (max_age - min_age)) * 100).to_i)
        end
      end      
    end
  end
  
  def name
    ine_id
  end
  
  include ActionController::UrlWriter
  
  def to_json(options = {})
    returning({}) do |h|
      h['text'] = "#{name}, #{city.name}"
      h['url'] = district_path(self)
    end.to_json(options)
  end
end

class District < ActiveRecord::Base
  belongs_to :city
  
  def self.normalize!
    max_age = District.maximum(:age)
    min_age = District.minimum(:age)
    all.each do |district|
      district.update_attributes!(:age_points => ((district.age - min_age) * (5.0 / (max_age - min_age)) * 100).to_i)
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

class District < ActiveRecord::Base
  belongs_to :city
  
  def self.normalize!
    all.map(&:city).uniq.each do |city|
      city.districts.each do |district|
        points = returning({}) do |h|
          NORMALIZED.each do |attribute|
            h["#{attribute}_points"] = if city.districts.size <= 1
              250
            else
              ((district[attribute] - ranges[attribute].begin) * (5.0 / (ranges[attribute].end - ranges[attribute].begin)) * 100).round
            end
          end
        end
        district.update_attributes!(points)
      end      
    end
  end
  
  NORMALIZED = [:age, :culture_and_sport]
  
  def self.ranges
    returning({}) do |h|
      NORMALIZED.each do |attribute|
        h[attribute] = (scoped({}).minimum(attribute)..scoped({}).maximum(attribute))
      end  
    end
  end
  
  include ActionController::UrlWriter
  
  def to_json(options = {})
    returning({}) do |h|
      h['text'] = "#{name}, #{city.name}"
      h['url'] = district_path(self)
    end.to_json(options)
  end
  
  def suggestions(limit = 6)
    dif = NORMALIZED.map { |a| "abs(d1.#{a}_points - d2.#{a}_points)" }.join("+")
    self.class.find_by_sql("select d1.*, #{dif} dif from districts d1 join districts d2 on d2.id=#{id} where d1.id != #{id} order by dif limit #{limit}")
  end
end

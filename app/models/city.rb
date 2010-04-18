class City < ActiveRecord::Base
  has_many :districts
  
  def to_param
    nicename
  end
end

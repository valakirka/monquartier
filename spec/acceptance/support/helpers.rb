module HelperMethods
  
  def create_city(attributes = {})
    City.create!(attributes)
  end
  
  def create_district(attributes = {})
    District.create!(attributes)
  end
  
end

Spec::Runner.configuration.include(HelperMethods)

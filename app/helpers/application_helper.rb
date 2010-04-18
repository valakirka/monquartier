module ApplicationHelper

  def get_gmaps_api_key
    if RAILS_ENV == "development" || RAILS_ENV == "test"
      "ABQIAAAAMNg-g2ZZT9PPIzZluAcuNxTJQa0g3IQ9GZqIMmInSLzwtGDKaBRmeiO9H0mVMRaNoIKfOODBKnVLSA"
    else
      "ABQIAAAAMNg-g2ZZT9PPIzZluAcuNxTdXksTpGeVaiVmlsQqghUFcmPIVRQDW0ridC190_39H16ENBtNz_sfZw"
    end
  end
  
  def cities_links
    City.all.sort_by { rand }.first(3).map { |city| link_to city.name, city_path(city) }.join(", ") + " ..."
  end
  
end

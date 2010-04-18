# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_gmaps_api_key
    if RAILS_ENV == "development" || RAILS_ENV == "test"
      "ABQIAAAAMNg-g2ZZT9PPIzZluAcuNxTJQa0g3IQ9GZqIMmInSLzwtGDKaBRmeiO9H0mVMRaNoIKfOODBKnVLSA"
    else
      "ABQIAAAAMNg-g2ZZT9PPIzZluAcuNxTdXksTpGeVaiVmlsQqghUFcmPIVRQDW0ridC190_39H16ENBtNz_sfZw"
    end
  end
end

class CitiesController < ApplicationController
  
  def show
    @city = City.find_by_nicename!(params[:id], :include => :districts)
  end
end

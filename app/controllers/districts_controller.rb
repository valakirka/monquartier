class DistrictsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js { render :json => District.all(:include => :city).to_json }
    end
  end
  
  def show
    @city = City.find_by_nicename!(params[:city_id])
    @district = @city.districts.find_by_nicename!(params[:id])
  end
end

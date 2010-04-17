class DistrictsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.js { render :json => District.all(:include => :city).to_json }
    end
  end
  
  def show
    @district = District.find(params[:id])
  end
end

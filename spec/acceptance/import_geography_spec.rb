require File.dirname(__FILE__) + '/acceptance_helper'

feature "Import geography" do
  
  scenario "Create basic data" do
    pending "Commented to avoid HTTP queries during tests"
    # Importer.import_city("Madrid")
    # 
    # City.count.should == 1
    # city = City.first
    # city.name.should == "Madrid"
    # city.nicename.should == "madrid"
    # city.districts.count.should == 21
    # city.districts.map(&:ine_id).should == (1..21).map {|i| "28079%02d" % i}
  end
  
  scenario "Add names to districts"
  
  scenario "Add geolocalization to districts"
  
end
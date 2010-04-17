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
  
  scenario "Get population for each district" do
    pending "Commented to avoid HTTP queries during tests"
    # city = create_city(:name => "Madrid", :ine_id => "28079")
    # district1 = create_district(:city => city, :ine_id => "2807901")
    # district2 = create_district(:city => city, :ine_id => "2807902")
    # district3 = create_district(:city => city, :ine_id => "2807903")
    # 
    # Importer.get_populations
    # 
    # district1.reload.population.should == 124_980
    # district2.reload.population.should == 133_022
    # district3.reload.population.should == 121_526
  end
  
  scenario "Add names to districts"
  
  scenario "Add geolocalization to districts"
  
end
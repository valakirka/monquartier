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
  
  scenario "Get population & normalized average age for each district" do
    # pending "Commented to avoid HTTP queries during tests"
    # city = create_city(:name => "Madrid", :ine_id => "28079")
    # district1 = create_district(:city => city, :ine_id => "2807901")
    # district2 = create_district(:city => city, :ine_id => "2807902")
    # district3 = create_district(:city => city, :ine_id => "2807903")
    # 
    # Importer.get_populations
    # 
    # district1.reload
    # district2.reload
    # district3.reload
    # 
    # district1.population.should == 124_980
    # district2.population.should == 133_022
    # district3.population.should == 121_526
    # 
    # district1.age.should == 4368
    # district2.age.should == 4158
    # district3.age.should == 4308
    # 
    # district1.age_points.should == 500
    # district2.age_points.should == 0
    # district3.age_points.should == 357 # http://twitpic.com/1g9bin
  end
  
  scenario "Add names to districts"
  
  scenario "Add geolocalization to districts"
  
end
class Importer
  def self.import_city(name)
    raise "City not found" unless cities.has_key?(name)
    puts "Creating city: #{name}"
    city = City.create!(:name => name, :nicename => name.nicename, :ine_id => cities[name]["ine_id"])
    url = "http://www.ine.es/prodyser/callejero/caj110/call_p#{cities[name]['province_id']}_110.zip"
    tmp_file = Rails.root.to_s + "/tmp/#{rand(10**9)}.zip"
    `curl #{url} > #{tmp_file}`
    `unzip -p #{tmp_file} "*TRAMOS*" | grep ^#{city.ine_id} | iconv -f ISO-8859-1 -t UTF-8 |cut -c 1-7 | uniq`.split("\n").each do |district_id|
      district_name = districts[district_id]
      puts "Creating district: #{district_name}, #{name}"
      city.districts.create!(:ine_id => district_id, :name => district_name, :nicename => district_name.nicename)
      
      way_location = `unzip -p #{tmp_file} "*TRAMOS*" | grep ^#{district_id} | iconv -f ISO-8859-1 -t UTF-8 | cut -c 166-190,136-160 | uniq`.split("\n").first
      location = way_location[0..24].strip
      way = way_location[25..50].strip
      way_type = `unzip -p #{tmp_file} "*VIAS*" | grep '#{way}' | iconv -f ISO-8859-1 -t UTF-8 | cut -c 28-32 | uniq`.split("\n").first.strip
      
      http = Resourceful::HttpAccessor.new
      resp = http.resource("http://maps.google.com/maps/geo?q=#{[way_type, way.gsub(/[' ']/, '+'), location.gsub(/[' ']/, '+')].join('+')}+,#{city.name}&output=csv&sensor=false&key=ABQIAAAAMNg-g2ZZT9PPIzZluAcuNxTJQa0g3IQ9GZqIMmInSLzwtGDKaBRmeiO9H0mVMRaNoIKfOODBKnVLSA").get

      District.find_by_ine_id(district_id).update_attributes!(:coordinates => resp.body.split(",").slice(2,2).join(","))
    end
    
    City.find_by_name("Madrid").districts.find_by_name("Salamanca").update_attributes!(:coordinates => "40.427284,-3.692436")
    City.find_by_name("Madrid").districts.find_by_name("Ciudad Lineal").update_attributes!(:coordinates => "38.74163,-5.672316")
  end
  
  def self.get_data
    puts "Getting data"
    session = IneSession.new
    City.all(:include => :districts).each do |city|
      puts "  -> #{city.name}"
      
      population_page = session.population_page(city)
      places_type_page = session.places_type_page(city)
      wealth_page = session.wealth_page(city)
      # puts wealth_page.to_xml; raise
      
      city.districts.each do |district|
        puts "    -> #{district.name}"
        ages = population_page.xpath("//table[@border='1']//tr[position()=1]/td[position()>2]").map {|cell| cell.text.to_i + 2.5}
        cells = population_page.xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat']").map {|cell| cell.text.gsub(/[^\d]/, '').to_i}
        population, values = cells.first, cells[1..-1]
        total = 0
        ages.each_with_index do |age, i|
          total += age * values[i]
        end
        age = total / population
        
        culture_and_sport = places_type_page.at_xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat' and position() = 6]").text.gsub(/[^\d]/, '').to_f * 1_000_000 / population
        
        # wealth = wealth_page.at_xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat' and position()=3]").text.gsub(/[^\d]/, '').to_i
        wealth = 10000 - wealth_page.at_xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat' and position()=7]").text.gsub(/[^\d]/, '').to_i
        
        district.update_attributes!(:population => population,
                                    :age => age * 100,
                                    :culture_and_sport => culture_and_sport,
                                    :wealth => wealth)
        
      end
      puts "    -> Normalizing data for #{city.name}"
      city.districts.normalize!
    end
    
  end

  def self.cities
    @cities ||= YAML.load_file(Rails.root.to_s + "/config/cities.yml")
  end
  
  def self.districts
    @districts ||= YAML.load_file(Rails.root.to_s + "/config/districts.yml")
  end

end

class Importer
  def self.import_city(name)
    raise "City not found" unless cities.has_key?(name)
    puts "Creating city: #{name}"
    city = City.create!(:name => name, :nicename => name.downcase, :ine_id => cities[name]["ine_id"])
    url = "http://www.ine.es/prodyser/callejero/caj110/call_p#{cities[name]['province_id']}_110.zip"
    tmp_file = Rails.root.to_s + "/tmp/#{rand(10**9)}.zip"
    `curl #{url} > #{tmp_file} && unzip -p #{tmp_file} "*TRAMOS*" | grep ^#{city.ine_id} | iconv -f ISO-8859-1 -t UTF-8 |cut -c 1-7 | uniq`.split("\n").each do |district_id|
      district_name = districts[district_id]
      puts "Creating district: #{district_name}, #{name}"
      city.districts.create!(:ine_id => district_id, :name => district_name)
    end
  end
  
  def self.get_data
    session = IneSession.new
    City.all(:include => :districts).each do |city|
      puts "Getting data for #{city.name}"
      
      population_page = session.population_page(city)
      places_type_page = session.places_type_page(city)
      
      city.districts.each do |district|
        ages = population_page.xpath("//table[@border='1']//tr[position()=1]/td[position()>2]").map {|cell| cell.text.to_i + 2.5}
        cells = population_page.xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat']").map {|cell| cell.text.gsub(/[^\d]/, '').to_i}
        population, values = cells.first, cells[1..-1]
        puts "Population of #{district.name}, #{city.name}: #{population}"
        total = 0
        ages.each_with_index do |age, i|
          total += age * values[i]
        end
        age = total / population
        
        culture_and_sport = places_type_page.at_xpath("//table[@border='1']//tr[td[contains(.,'#{district.ine_id}')]]/td[@class='dat' and position() = 6]").text.gsub(/[^\d]/, '').to_f * 1_000_000 / population
        puts "Culture & Sport in #{district.name}, #{city.name}: #{culture_and_sport}"
        
        district.update_attributes!(:population => population,
                                    :age => age * 100,
                                    :culture_and_sport => culture_and_sport)
      end
      puts "Normalizing data for #{city.name}"
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

class Importer
  def self.import_city(name)
    raise "City not found" unless cities.has_key?(name)
    city = City.create!(:name => name, :nicename => name.downcase, :ine_id => cities[name]["ine_id"])
    url = "http://www.ine.es/prodyser/callejero/caj110/call_p#{cities[name]['province_id']}_110.zip"
    tmp_file = Rails.root.to_s + "/tmp/#{rand(10**9)}.zip"
    puts "curl #{url} > #{tmp_file} && unzip -p #{tmp_file} \"*TRAMOS*\" | grep ^#{city.ine_id} | iconv -f ISO-8859-1 -t UTF-8 |cut -c 1-7 | uniq"
    `curl #{url} > #{tmp_file} && unzip -p #{tmp_file} "*TRAMOS*" | grep ^#{city.ine_id} | iconv -f ISO-8859-1 -t UTF-8 |cut -c 1-7 | uniq`.split("\n").each do |district_id|
      city.districts.create!(:ine_id => district_id)
    end
  end
  
  def self.cities
    @cities ||= YAML.load_file(Rails.root.to_s + "/config/cities.yml")
  end
end

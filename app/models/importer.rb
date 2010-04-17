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
  
  def self.get_populations
    session = IneSession.new
    City.all(:include => :districts).each do |city|
      session.post("http://www.ine.es/censo/es/seleccion_infra_elec_sec_dist.jsp",
                          :fType => 5,
                          :municipios => city.ine_id,
                          :select_municipio => city.ine_id,
                          :select_provincia => city.ine_id.first(2),
                          :subtipoInfra => "D")
      session.post("http://www.ine.es/censo/es/seleccion_colectivo.jsp",
                          "municipios=#{city.ine_id}&subtipoInfra=D&" + 
                          city.districts.map { |d| "select_distritos=#{d.ine_id}" }.join("&") +
                          "&fType=5",
                          "Content-Type" => "application/x-www-form-urlencoded")
      page = session.post("http://www.ine.es/censo/es/consulta.jsp",
                          :_IDIOMA => "ES",
                          :c => "GRUPO_Q_EDAD",
                          :k => "MDDB.COLECTIVO_P1M",
                          :m => "SPERSONAS",
                          :r => "DISTRITO",
                          :s => 1)
      city.districts.each do |district|
        district.update_attributes!(:population => page.root.at_xpath("//table[@border='1']//*[preceding-sibling::td[contains(.,'#{district.ine_id}')]]").text.gsub(/[^\d]/, '').to_i)
      end
    end
  end
  
  def self.cities
    @cities ||= YAML.load_file(Rails.root.to_s + "/config/cities.yml")
  end
end

class IneSession < Mechanize
  
  def initialize
    super
    get("http://www.ine.es/censo/es/inicio.jsp")
  end
  
  def population_page(city)
    page(city, :_IDIOMA => "ES",
               :c => "GRUPO_Q_EDAD",
               :k => "MDDB.COLECTIVO_P1M",
               :m => "SPERSONAS",
               :r => "DISTRITO",
               :s => 1)
  end
  
  def places_type_page(city)
    page(city, :_IDIOMA => "ES",
               :c => "TIPO_LOCAL",
               :k => "MDDB.COLECTIVO_V6M",
               :m => "SLOCALES",
               :r => "DISTRITO",
               :s => 1)
  end
  
  def page(city, options = {})
    post("http://www.ine.es/censo/es/seleccion_infra_elec_sec_dist.jsp",
                :fType => 5,
                :municipios => city.ine_id,
                :select_municipio => city.ine_id,
                :select_provincia => city.ine_id.first(2),
                :subtipoInfra => "D")
    post("http://www.ine.es/censo/es/seleccion_colectivo.jsp",
                "municipios=#{city.ine_id}&subtipoInfra=D&" + 
                city.districts.map { |d| "select_distritos=#{d.ine_id}" }.join("&") +
                "&fType=5",
                "Content-Type" => "application/x-www-form-urlencoded")
                
    post("http://www.ine.es/censo/es/consulta.jsp", options).root
  end
  
end
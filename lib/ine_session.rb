class IneSession < Mechanize
  
  def initialize
    super
    get("http://www.ine.es/censo/es/inicio.jsp")
  end
  
end
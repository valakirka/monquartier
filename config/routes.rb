ActionController::Routing::Routes.draw do |map|
  map.root :controller => :districts
  map.resources :cities do |city|
    city.resources :districts
  end
  map.resources :districts
  map.connect "que-es-monquartier", :controller => "districts", :action => "about"
  map.connect "datos", :controller => "districts", :action => "data"
end

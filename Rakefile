# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

task :import => :environment do
  City.delete_all
  District.delete_all
  Importer.cities.each do |name, data|
    Importer.import_city(name)
  end
  Importer.get_data
end
# frozen_string_literal: true

require 'rake'
require_relative 'cars_delete'
require_relative 'cars_add'
CARS_PATH = 'cars.yml'

namespace :cars do # rake cars:delete_cars
  desc 'Delete all cars'
  task :delete_cars do
    CarsDelete.new.delete_cars
  end

  desc 'Add a car' # rake cars:add_car
  task :add_car do
    cars_db = YamlLoad.new(CARS_PATH).data || []
    new_car = CarsAdd.new.to_hash
    cars_db.push(new_car)
    File.open(CARS_PATH, 'w') { |f| YAML.dump(cars_db, f) }
  end

  desc 'Add N cars' # rake cars:add_cars cars_number=3
  task :add_cars do
    cars_db = YamlLoad.new(CARS_PATH).data || []
    cars_number = ENV['cars_number'].to_i
    i = 1
    while i <= cars_number
      new_car = CarsAdd.new.to_hash
      cars_db.push(new_car)
      File.open(CARS_PATH, 'w') { |f| YAML.dump(cars_db, f) }
      i += 1
    end
  end
end

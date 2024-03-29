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

  desc 'Add N cars' # rake cars:add_cars || cars:add_cars cars_number=3
  task :add_cars do
    cars_db = YamlLoad.new(CARS_PATH).data.empty? ? [] : YamlLoad.new(CARS_PATH).data
    cars_number = ENV['cars_number'].nil? ? 1 : ENV['cars_number'].to_i
    cars_number.times do
      new_car = CarsAdd.new.to_hash
      cars_db.push(new_car)
    end
    File.open(CARS_PATH, 'w') { |f| YAML.dump(cars_db, f) }
  end
end

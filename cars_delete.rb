# frozen_string_literal: true

require 'yaml'
require_relative 'yaml_load'

class CarsDelete

  CARS_PATH = 'cars.yml'

  def delete_cars
    File.open(CARS_PATH, 'w') { |f| f.truncate(0) }
  end
end

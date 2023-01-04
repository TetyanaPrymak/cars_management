# frozen_string_literal: true

require 'yaml'
require_relative 'yaml_load'

class CarsDelete
  attr_accessor :cars_db

  CARS_PATH = 'cars.yml'

  def initialize
    @cars_db = YamlLoad.new(CARS_PATH).data
  end

  def delete_cars
    cars_db.clear
    File.open(CARS_PATH, 'w'){ |f| YAML.dump(cars_db,f) }
  end
end

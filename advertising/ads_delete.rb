# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'
require_relative 'ads_validator'

class AdsDelete
  include MessagePrinter
  attr_accessor :cars_db, :ads_car

  CARS_PATH = 'cars.yml'

  def initialize
    @cars_db = YamlLoad.new(CARS_PATH).data
  end

  def call
    print_message(:ads_delete)
    id_delete = gets.chomp
    found = @cars_db.find_index { |cars_db| cars_db.value?(id_delete) }
    if found.nil?
      print_message(:delete_error)
    else
      @cars_db.delete_at(found)
      File.open(CARS_PATH, 'w') { |file| file.write(@cars_db.to_yaml) }
      print_message(:delete_success)
      puts " #{id_delete} "
    end
  end
end

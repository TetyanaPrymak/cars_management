# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'
require_relative 'ads_check'

class AdsUpdate
  include MessagePrinter
  attr_accessor :cars_db, :ads_car, :found

  CARS_PATH = 'cars.yml'

  def initialize
    @ads_check = AdsCheck.new
    @cars_db = YamlLoad.new(CARS_PATH).data
  end

  def call
    find_ads
    if found.nil?
      print_message(:delete_error)
      @ads_validated = false
    else
      @ads_car = @cars_db[found]
      update_elements
      validate_ads_elements
      update_ads_car
    end
  end

  def find_ads
    print_message(:ads_update)
    id_update = gets.chomp
    @found = @cars_db.find_index { |cars_db| cars_db.value?(id_update) }
  end

  def update_elements
    @ads_car.each do |key, value|
      unless key == 'id' || key == 'date_added'
        print_message(:ads_element_update)
        puts key
        input = gets.chomp
        unless input.empty?
          @ads_car[key] = input
        end
      end
    end
  end

  def validate_ads_elements
    @ads_check.validate_ads_make(@ads_car['make'])
    @ads_check.validate_ads_model(@ads_car['model'])
    @ads_check.validate_ads_year(@ads_car['year'])
    @ads_check.validate_ads_odometer(@ads_car['odometer'])
    @ads_check.validate_ads_price(@ads_car['price'])
    @ads_check.validate_ads_description(@ads_car['description'])
    @ads_validated = @ads_check.ads_elements_validated?
  end

  def update_ads_car
    if @ads_validated
      print_message(:update_success)
      puts " #{@ads_car['id']} "
      @cars_db[@found] = @ads_car
      File.open(CARS_PATH, 'w') { |file| file.write(@cars_db.to_yaml) }
    else
      print_message(:update_error)
    end
  end
end

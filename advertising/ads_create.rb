# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'
require_relative 'ads_check'

class AdsCreate
  include MessagePrinter
  attr_accessor :cars_db, :ads_car

  CARS_PATH = 'cars.yml'

  def initialize
    @ads_check = AdsCheck.new
    print_message(:ads_request)
    @cars_db = YamlLoad.new(CARS_PATH).data
  end

  def call
    create_ads
    validate_ads_elements
    add_ads_car
  end

  def create_ads
    print_message(:ads_make)
    @ads_make = gets.chomp
    print_message(:ads_model)
    @ads_model = gets.chomp
    print_message(:ads_year)
    @ads_year = gets.chomp
    print_message(:ads_odometer)
    @ads_odometer = gets.chomp
    print_message(:ads_price)
    @ads_price = gets.chomp
    print_message(:ads_description)
    @ads_description = gets.chomp
  end

  def validate_ads_elements
    @ads_check.validate_ads_make(@ads_make)
    @ads_check.validate_ads_model(@ads_model)
    @ads_check.validate_ads_year(@ads_year)
    @ads_check.validate_ads_odometer(@ads_odometer)
    @ads_check.validate_ads_price(@ads_price)
    @ads_check.validate_ads_description(@ads_description)
    @ads_validated = @ads_check.ads_elements_validated?
    @ads_car = @ads_check.ads_car
    @ads_car['id'] = SecureRandom.uuid
    @ads_car['date_added'] = Time.now.strftime('%d/%m/%y')
    @ads_car = @ads_car.slice('id', 'make', 'model', 'year', 'odometer', 'price', 'description', 'date_added')
  end

  def add_ads_car
    if @ads_validated
      print_message(:ads_success)
      puts " #{ads_car['id']} "
      @cars_db.push(ads_car)
      File.open(CARS_PATH, 'w') { |file| file.write(@cars_db.to_yaml) }
    else
      print_message(:ads_error)
    end
  end
end

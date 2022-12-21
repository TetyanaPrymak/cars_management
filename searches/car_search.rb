# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'
require_relative '../console_print'
require_relative 'car_filter'
require_relative 'car_sort'
require_relative 'cars_archive'

class CarSearch
  include MessagePrinter
  attr_accessor :car_filter, :sorted_result

  CARS_PATH = 'cars.yml'
  SEARCHES_PATH = 'searches.yml'
  RULES_MAKE_MODEL = %w[make model].freeze
  RULES_YEAR = %w[year_from year_to].freeze
  RULES_PRICE = %w[price_from price_to].freeze

  def initialize
    print_message(:invitation)
    car_filter = CarFilter.new
    RULES_MAKE_MODEL.each do |rule|
      car_filter.text_rules(rule)
    end
    RULES_YEAR.each do |rule|
      car_filter.year_rules(rule)
    end
    RULES_PRICE.each do |rule|
      car_filter.price_rules(rule)
    end
    @car_filter = car_filter
  end

  def call
    use_rules
    print_search
    put_to_archive
  end

  def use_rules
    cars_db = YamlLoad.new(CARS_PATH).data
    cars_db.keep_if { |car_db| car_filter.car_matches?(car_db) }
    cars_total = cars_db.length

    cars_sort = CarSort.new(car_filter, cars_db)
    @sorted_result = cars_sort.call
  end

  def print_search
    car_print = ConsolePrint.new(sorted_result, I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
                                 [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)])
    puts car_print.call
  end

  def put_to_archive
    searches_archive = YamlLoad.new(SEARCHES_PATH).data

    cars_archive = CarsArchive.new(car_filter.to_archive, searches_archive, car_filter.cars_total)
    cars_archive.call

    File.open('searches.yml', 'w') { |file| file.write(searches_archive.to_yaml) }
  end
end

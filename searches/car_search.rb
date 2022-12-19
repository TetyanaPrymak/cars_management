# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'
require_relative '../console_print'
require_relative 'car_filter'
require_relative 'car_sort'
require_relative 'cars_archive'

class CarSearch < MenuOption
  attr_accessor :car_filter, :sorted_result, :cars_db

  RULES_MAKE_MODEL = %w[make model].freeze
  RULES_YEAR = %w[year_from year_to].freeze
  RULES_PRICE = %w[price_from price_to].freeze

  def start_search
    puts print_message(:invitation)
    @car_filter = CarFilter.new
  end

  def make_rules
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

  def use_rules
    @cars_db = YamlLoad.new(CARS_PATH).data
    cars_db.keep_if { |car_db| @car_filter.car_matches?(car_db) }

    @car_filter.sort_rules
    sort_option = car_filter.sort_option
    sort_direction = car_filter.sort_direction

    cars_sort = CarSort.new(cars_db, sort_option, sort_direction)
    cars_sort.date_convert
    @sorted_result = cars_sort.sorting
  end

  def print_search
    car_print = ConsolePrint.new(sorted_result, I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
                                 [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)])
    puts car_print.printing_to_console
  end

  def put_to_archive
    searches_archive = YamlLoad.new(SEARCHES_PATH).data
    cars_total = @cars_db.length

    cars_archive = CarsArchive.new(@car_filter.to_archive, searches_archive, cars_total)
    cars_archive.write_to_archive

    File.open('searches.yml', 'w') { |file| file.write(searches_archive.to_yaml) }
  end

  def run
    start_search
    make_rules
    use_rules
    print_search
    put_to_archive
  end
end

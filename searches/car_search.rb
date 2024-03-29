# frozen_string_literal: true

require 'date'
require 'colorize'
require_relative 'car_filter'
require_relative 'car_sort'
require_relative 'cars_archive'
require_relative '../users/users_archive'

class CarSearch
  include MessagePrinter
  attr_accessor :car_filter, :car_sort, :sorted_result, :cars_db, :email

  CARS_PATH = 'cars.yml'
  SEARCHES_PATH = 'searches.yml'
  USERS_SEARCHES_PATH = 'user_searches.yml'
  RULES_MAKE_MODEL = %w[make model].freeze
  RULES_YEAR = %w[year_from year_to].freeze
  RULES_PRICE = %w[price_from price_to].freeze
  RULES_SORT = %w[sorting_request direction_request].freeze

  def initialize(email)
    @email = email
    @car_filter = CarFilter.new(@email)
    @car_sort = CarSort.new
    @cars_db = YamlLoad.new(CARS_PATH).data
  end

  def make_rules
    RULES_MAKE_MODEL.each do |rule|
      car_filter.text_rules(rule, :option_request)
    end
    RULES_YEAR.each do |rule|
      car_filter.year_rules(rule, :option_request)
    end
    RULES_PRICE.each do |rule|
      car_filter.price_rules(rule, :option_request)
    end
    RULES_SORT.each do |rule|
      car_sort.call(rule, :option_request)
    end
  end

  def call
    print_message(:invitation)
    make_rules
    date_convert
    use_rules
    print_search
    put_to_archive
    put_users_searches
  end

  def date_convert
    cars_db.each do |car_db|
      car_db['date_added'] = Date.strptime(car_db['date_added'], '%d/%m/%y')
    end
  end

  def use_rules
    cars_result = cars_db.keep_if { |car_db| @car_filter.car_matches?(car_db) }
    @sorted_result = @car_sort.sorting(cars_result)
  end

  def print_search
    car_print = PrepareConsoleOutput.new(
      sorted_result,
      I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
      [
        I18n.t(:INDEX).colorize(:yellow),
        I18n.t(:VALUE).colorize(:yellow)
      ]
    )
    puts car_print.call
  end

  def put_to_archive
    searches_archive = YamlLoad.new(SEARCHES_PATH).data

    cars_archive = CarsArchive.new(car_filter.to_archive, searches_archive, cars_db.length)
    cars_archive.call
    File.open('searches.yml', 'w') { |file| file.write(searches_archive.to_yaml) }
  end

  def put_users_searches
    users_searches = YamlLoad.new(USERS_SEARCHES_PATH).data

    users_archive = UsersArchive.new(@email, car_filter.to_archive, users_searches)
    unless @email.nil? || @email == 'not_signed'
      users_archive.put_user_search
    end

    File.open('user_searches.yml', 'w') { |file| file.write(users_searches.to_yaml) }
  end
end

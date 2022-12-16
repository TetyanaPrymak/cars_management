# frozen_string_literal: true

require 'yaml'
require 'date'
require 'terminal-table'
require 'i18n'
require 'colorize'

cars_db = YAML.safe_load(File.read(CARS_PATH), permitted_classes: [Symbol])
searches_archive = YAML.safe_load(File.read(SEARCHES_PATH), permitted_classes: [Symbol]) || {}

puts print_message(:invitation)

class FilterRequest
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :sort_option, :sort_direction

  def initialize
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
    @sort_option = sort_option
    @sort_direction = sort_direction
  end

  def text_input?(user_input)
    user_input =~ /\D/
  end

  def can_capitalize?(user_input)
    user_input =~ /^[A-Za-z].*/
  end

  def text_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    if can_capitalize? (user_input)
      user_input.capitalize!
    end
    rule == 'make' ? @make = user_input : @model = user_input
  end

  def year_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    year = text_input?(user_input) ? '' : user_input
    rule == 'year_from' ? @year_from = year : @year_to = year
  end

  def price_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    price = text_input?(user_input) ? '' : user_input
    rule == 'price_from' ? @price_from = price : @price_to = price
  end

  def sort_rules
    print_message(:sorting_request)
    sort_option = gets.chomp
    @sort_option = sort_option == I18n.t(:price) ? BY_PRICE : BY_DATE_ADDED
    print_message(:direction_request)
    sort_direction = gets.chomp
    @sort_direction = sort_direction == I18n.t(:direction) ? 'asc' : DIRECTION
  end
end

class CarFilter < FilterRequest
  def equal?(user_input, db_value)
    (user_input.empty? || user_input.casecmp?(db_value))
  end

  def between?(user_input_from, user_input_to, db_value)
    (user_input_from.empty? || user_input_from.to_i <= db_value) &&
      (user_input_to.empty? || user_input_to.to_i >= db_value)
  end

  def car_matches?(car_db)
    equal?(@make, car_db['make']) &&
      equal?(@model, car_db['model']) &&
      between?(@year_from, @year_to, car_db['year']) &&
      between?(@price_from, @price_to, car_db['price'])
  end

  def to_archive
    { 'make': @make, 'model': @model, 'year_from': @year_from, 'year_to': @year_to,
      'price_from': @price_from, 'price_to': @price_to }
  end
end

class CarSort
  attr_accessor :cars_db, :sort_option, :sort_direction

  def initialize(cars_db, sort_option, sort_direction)
    @sort_option = sort_option
    @sort_direction = sort_direction
    @cars_db = cars_db
  end

  def date_convert
    @cars_db.each do |car_db|
      car_db['date_added'] = Date.strptime(car_db['date_added'], '%d/%m/%y')
    end
  end

  def sorting
    if sort_direction == 'asc'
      @cars_db.sort! { |car1, car2| car1[sort_option] <=> car2[sort_option] }
    else
      @cars_db.sort! { |car1, car2| car2[sort_option] <=> car1[sort_option] }
    end
  end
end

class CarsArchive
  attr_accessor :search, :searches_archive, :cars_total

  def initialize(search, searches_archive, cars_total)
    @search = search
    @searches_archive = searches_archive
    @cars_total = cars_total
  end

  def write_to_archive
    if @searches_archive.key?(@search)
      search_number = @searches_archive[@search][:Requests]
      search_number += 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total }
    else
      search_number = 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total }
    end
  end
end

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

cars_db.keep_if { |car_db| car_filter.car_matches?(car_db) }

car_filter.sort_rules
sort_option = car_filter.sort_option
sort_direction = car_filter.sort_direction

cars_sort = CarSort.new(cars_db, sort_option, sort_direction)
cars_sort.date_convert
sorted_result = cars_sort.sorting

car_print = ConsolePrint.new(sorted_result, I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
                             [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)])
puts car_print.printing_to_console

cars_total = cars_db.length
cars_archive = CarsArchive.new(car_filter.to_archive, searches_archive, cars_total)
cars_archive.write_to_archive

File.open('searches.yml', 'w') { |file| file.write(searches_archive.to_yaml) }

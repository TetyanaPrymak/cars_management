# frozen_string_literal: true

require 'yaml'
require 'date'
require 'terminal-table'
require 'i18n'
require 'colorize'

CARS_PATH = 'cars.yml'
SEARCHES_PATH = 'searches.yml'
BY_PRICE = 'price'
BY_DATE_ADDED = 'date_added'
DIRECTION = 'desc'
RULES_MAKE_MODEL = %w[make model].freeze
RULES_YEAR = %w[year_from year_to].freeze
RULES_PRICE = %w[price_from price_to].freeze
cars_db = YAML.safe_load(File.read(CARS_PATH), permitted_classes: [Symbol])
searches_archive = YAML.safe_load(File.read(SEARCHES_PATH), permitted_classes: [Symbol]) || {}

def print_message(key)
  puts I18n.t(key)
end

puts print_message(:invitation)

class Car
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to

  def initialize
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
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

  def car_matches?(car_db)
    equal?(@make, car_db['make']) &&
      equal?(@model, car_db['model']) &&
      between?(@year_from, @year_to, car_db['year']) &&
      between?(@price_from, @price_to, car_db['price_to'])
  end

  def sort_cars(sort_option)
    return @price if sort_option == BY_PRICE
    return @date_added if sort_option == BY_DATE_ADDED
  end

  def to_archive
    { 'make': @make, 'model': @model, 'year_from': @year_from, 'year_to': @year_to,
      'price_from': @price_from, 'price_to': @price_to }
  end
end

car_filter = Car.new

RULES_MAKE_MODEL.each do |rule|
  car_filter.text_rules(rule)
end

RULES_YEAR.each do |rule|
  car_filter.year_rules(rule)
end

RULES_PRICE.each do |rule|
  car_filter.price_rules(rule)
end

puts I18n.t(:sorting_request)
sort_option = gets.chomp
sort_option = sort_option == I18n.t(:price) ? BY_PRICE : BY_DATE_ADDED

print_message(:direction_request)
sort_direction = gets.chomp
sort_direction = sort_direction == I18n.t(:direction) ? 'asc' : DIRECTION

def equal?(user_input, db_value)
  (user_input.empty? || user_input.casecmp?(db_value))
end

def between?(user_input_from, user_input_to, db_value)
  (user_input_from.empty? || user_input_from.to_i <= db_value) &&
    (user_input_to.empty? || user_input_to.to_i >= db_value)
end

cars_db.keep_if { |car_db| car_filter.car_matches?(car_db) }

cars_db.each do |car_db|
  car_db['date_added'] = Date.strptime(car_db['date_added'], '%d/%m/%y')
end

sorted_result = if sort_direction == 'asc'
                  cars_db.sort! { |car1, car2| car1[sort_option] <=> car2[sort_option] }
                else
                  cars_db.sort! { |car1, car2| car2[sort_option] <=> car1[sort_option] }
                end
cars_total = sorted_result.length

table_title = I18n.t(:SEARCH_RESULTS).colorize(:light_blue)
table_heading = [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)]
def results_table(data, table_title, table_heading)
  Terminal::Table.new title: table_title, headings: table_heading do |t|
    data.each do |car|
      car.each do |key, value|
        rows = [key, value]
        t.add_row rows
        t.style = { border_bottom: false, padding_left: 3, border_x: '=', border_i: 'x' }
      end
      t << :separator
    end
  end
end
puts results_table(cars_db, table_title, table_heading)

search = car_filter.to_archive

if searches_archive.key?(search)
  search_number = searches_archive[search][:Requests]
  search_number += 1
  searches_archive[search] = { Requests: search_number, Total: cars_total }
else
  search_number = 1
  searches_archive[search] = { Requests: search_number, Total: cars_total }
end

File.open('searches.yml', 'w') { |file| file.write(searches_archive.to_yaml) }

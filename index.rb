require 'yaml'
require 'date'
require 'terminal-table'
require 'i18n'
require 'colorize'

CARS_PATH = 'cars.yml'.freeze
SEARCHES_PATH = 'searches.yml'.freeze
BY_PRICE = 'price'.freeze
BY_DATE_ADDED = 'date_added'.freeze
DIRECTION = 'desc'.freeze
RULES_LIST_TEXT = ["make", "model"].freeze
RULES_LIST_NUMBER = ["year_from", "year_to", "price_from", "price_to"].freeze
LANG_LIST = ['en', 'ua'].freeze
DEFAULT_LANGUAGE = :en.freeze
cars = YAML.load(File.read(CARS_PATH))
searches_archive = YAML.load(File.read(SEARCHES_PATH)) || {}
filter_list = {}
filter_result = []
cars_total = 0

puts "Please choose language (en | ua): "
user_lang = gets.chomp
I18n.load_path += Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.default_locale = :en

I18n.locale = LANG_LIST.include?(user_lang) ? user_lang.to_sym : DEFAULT_LANGUAGE

def text_input?(user_input)
  user_input =~ /\D/
end

def can_capitalize?(user_input)
  user_input =~ /^[A-Za-z].*/
end

def print_message(key)
  puts I18n.t(key)
end

puts print_message(:invitation)
RULES_LIST_TEXT.each do |rule|
  rule_localized = I18n.t(rule)
  print_message(:option_request)
  print " #{rule_localized}: "
  user_input = gets.chomp
  filter_list[rule] = user_input
end

RULES_LIST_NUMBER.each do |rule|
  rule_localized = I18n.t(rule)
  print_message(:option_request)
  print " #{rule_localized}: "
  user_input = gets.chomp
  if text_input?(user_input)
    filter_list[rule] = ""
  else
    filter_list[rule] = user_input
  end
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

def car_matches?(filter_list, car)
  equal?(filter_list["make"], car["make"]) &&
  equal?(filter_list["model"], car["model"]) &&
  between?(filter_list["year_from"], filter_list["year_to"], car["year"]) &&
  between?(filter_list["price_from"], filter_list["price_to"], car["price"])
end

cars.each do |car|
  next unless car_matches?(filter_list, car)
  car["date_added"] = Date.strptime(car["date_added"], '%d/%m/%y')
  if can_capitalize?(car["make"])
    car["make"].capitalize!
  end
  if can_capitalize?(car["model"])
    car["model"].capitalize!
  end
  filter_result << car
end

if sort_direction == "asc"
  sorted_result = filter_result.sort { |a,b| a[sort_option] <=> b[sort_option] }
else
  sorted_result = filter_result.sort { |a,b| b[sort_option] <=> a[sort_option] }
end

cars_total = sorted_result.length()

rows = []

def print_table(table_data)
  table = Terminal::Table.new :title => I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
  :headings => [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)] do |t|
    table_data.each do |car|
      car.each do |key, value|
        rows = [key, value]
        t.add_row rows
        t.style = {:border_bottom => false, :padding_left => 3, :border_x => "=", :border_i => "x"}
      end
      t << :separator
    end
  end
  puts table
end

print_table(sorted_result)

if searches_archive.has_key?(filter_list)
  search_number = searches_archive[filter_list][:Requests]
  search_number = search_number + 1
  searches_archive[filter_list] = {Requests: search_number, Total: cars_total}
else
  search_number = 1
  searches_archive.merge!({filter_list => {Requests: search_number, Total: cars_total}})
end

File.open("searches.yml", "w") { |file| file.write(searches_archive.to_yaml) }

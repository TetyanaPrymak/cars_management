require 'yaml'
require 'date'

CARS_PATH = 'cars.yml'.freeze
SEARCHES_PATH = 'searches.yml'.freeze
BY_PRICE = 'price'.freeze
BY_DATE_ADDED = 'date_added'.freeze
ALLOWED_SORT_OPTIONS = [BY_PRICE, BY_DATE_ADDED].freeze
RULES_LIST = ["make", "model", "year_from", "year_to", "price_from", "price_to"].freeze
cars = YAML.load(File.read(CARS_PATH))
search_archive = YAML.load(File.read(SEARCHES_PATH))
filter_list = {}
filter_result = []
cars_number = 0

if search_archive == false then search_archive = {} end

puts "Please select search rules."
RULES_LIST.each do |rule|
  puts "Please choose #{rule}: "
  user_input = gets.chomp
  if user_input.scan(/\D/).empty?
    filter_list[rule] = user_input
  else
    filter_list[rule] = user_input.capitalize!
  end
end

puts "Please choose sort option (date_added|price): "
sort_option = gets.chomp
puts "Please choose sort direction(desc|asc): "
sort_direction = gets.chomp

def equal?(user_input, db_value)
  user_input.empty? || user_input.casecmp?(db_value)
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
  filter_result << car
end

sort_option = ALLOWED_SORT_OPTIONS.include?(sort_option) ? sort_option : BY_DATE_ADDED

if sort_direction == "asc"
  sorted_result = filter_result.sort { |a,b| a[sort_option] <=> b[sort_option] }
else
  sorted_result = filter_result.sort { |a,b| b[sort_option] <=> a[sort_option] }
end

cars_number = sorted_result.length()

if search_archive.has_key?(filter_list)
  search_number = search_archive[filter_list][:Requests]
  search_number = search_number + 1
  search_archive[filter_list] = {Requests: search_number, Total: cars_number}
else
  search_number = 1
  search_archive.merge!({filter_list => {Requests: search_number, Total: cars_number}})
end

puts '-' * 40
puts 'Statistic:'
print 'Total Quantity: '
puts cars_number
print "Requests quantity: "
puts search_number
puts '-' * 40
puts 'Results: '
sorted_result.each do |result|
  result["date_added"] = result["date_added"].strftime("%d/%m/%Y")
  result.each do |key, value|
    puts key.to_s + ': ' + value.to_s
  end
puts '-' * 40
end
File.open("searches.yml", "w") { |file| file.write(search_archive.to_yaml) }

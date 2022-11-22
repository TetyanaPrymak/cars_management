require 'yaml'
require 'date'

FILE_PATH = 'cars.yml'.freeze
cars = YAML.load(File.read(FILE_PATH))
filter_list = {}
filter_result = []
RULES_LIST = ["make", "model", "year_from", "year_to", "price_from", "price_to"].freeze

puts "Please select search rules."
RULES_LIST.each do |rule|
  puts "Please choose #{rule}: "
  user_input = gets.chomp
  filter_list[rule] = user_input
end

puts "Please choose sort option (date_added|price): "
sort_option = gets.chomp
puts "Please choose sort direction(desc|asc): "
sort_direction = gets.chomp

def equal?(user_input, db_value)
  user_input.empty? || user_input.casecmp?(db_value)
end

def between_then?(user_input_from, user_input_to, db_value)
  (user_input_from.empty? || user_input_from.to_i <= db_value)&&
  (user_input_to.empty? || user_input_to.to_i >= db_value)
end

def conditions_ok?(filter_list, car)
  equal?(filter_list["model"], car["model"]) &&
  between_then?(filter_list["year_from"], filter_list["year_to"], car["year"]) &&
  between_then?(filter_list["price_from"], filter_list["price_to"], car["price"])
end

cars.each do |car|
  if conditions_ok?(filter_list, car)
    car["date_added"] = Date.strptime(car["date_added"], '%d/%m/%y')
    filter_result << car
  end
end

BY_PRICE = 'price'.freeze
BY_DATE_ADDED = 'date_added'.freeze
ALLOWED_SORT_OPTIONS = [BY_PRICE, BY_DATE_ADDED].freeze
sort_option = ALLOWED_SORT_OPTIONS.include?(sort_option) ? sort_option : BY_DATE_ADDED

if sort_direction == "asc"
  sorted_result = filter_result.sort { |a,b| a[sort_option] <=> b[sort_option] }
else
  sorted_result = filter_result.sort { |a,b| b[sort_option] <=> a[sort_option] }
end

puts '-' * 40
puts 'Results: '
sorted_result.each do |result|
  result["date_added"] = result["date_added"].strftime("%d/%m/%Y")
  result.each do |key, value|
    puts key.to_s + ': ' + value.to_s
  end
puts '-' * 40
end

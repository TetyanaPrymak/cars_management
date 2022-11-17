require 'yaml'
require 'date'

data = YAML.load(File.read('cars.yml'))
filter_list = {}
filter_result = []
rules_list = ["make", "model", "year_from", "year_to", "price_from", "price_to"]

puts "Please select search rules."
for i in rules_list
  puts "Please choose #{i}: "
  elem = gets.chomp
  filter_list[i] = elem
end
puts "Please choose sort option (date_added|price): "
sort_opt = gets.chomp
puts "Please choose sort direction(desc|asc): "
sort_dir = gets.chomp
for i in data
  if (filter_list["make"] == "" or filter_list["make"] == i["make"]) and
    (filter_list["model"] == "" or filter_list["model"] == i["model"]) and
    (filter_list["year_from"] == "" or filter_list["year_from"].to_i <= i["year"].to_i) and
    (filter_list["year_to"] == "" or filter_list["year_to"].to_i >= i["year"].to_i) and
    (filter_list["price_from"] == "" or filter_list["price_from"].to_i <= i["price"].to_i) and
    (filter_list["price_to"] == "" or filter_list["price_to"].to_i  >= i["price"].to_i)
    i["date_added"] = Date.strptime(i["date_added"], '%d/%m/%y')
    filter_result.push(i)
  end
end
if sort_opt != "price"
  sort_opt = "date_added"
end
if sort_dir == "asc"
  filter_result_sorted = filter_result.sort { |a,b| a[sort_opt] <=> b[sort_opt] }
else
  filter_result_sorted = filter_result.sort { |a,b| b[sort_opt] <=> a[sort_opt] }
end
puts "---------------------------------------\nResults:"
for i in filter_result_sorted
  i.each do |key, value|
    puts key.to_s + ': ' + value.to_s
end
puts "---------------------------------------\n"
end

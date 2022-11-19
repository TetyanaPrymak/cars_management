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

def comp_eq(cond, li)
  if cond == "" or di == li then true end
end

def comp_less(cond, li)
  if cond == "" or cond.to_i <= li.to_i then true end
end

def comp_more(cond, li)
  if cond == "" or cond.to_i <= li.to_i then true end
end

for i in data
  if comp_eq(filter_list["make"], i["make"]) and
    comp_eq(filter_list["model"], i["model"]) and
    comp_less(filter_list["year_from"], i["year"]) and
    comp_more(filter_list["year_to"], i["year"]) and
    comp_less(filter_list["price_from"], i["price"]) and
    comp_more(filter_list["year_to"], i["price"])
    i["date_added"] = Date.strptime(i["date_added"], '%d/%m/%y')
    filter_result.push(i)
  end
end

if sort_opt != "price" then sort_opt = "date_added" end
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

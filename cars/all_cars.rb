require 'yaml'
require 'terminal-table'
require 'i18n'
require 'colorize'

CARS_PATH = 'cars.yml'.freeze
cars_db = YAML.safe_load(File.read(CARS_PATH), permitted_classes: [Symbol])

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

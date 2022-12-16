# frozen_string_literal: true

require 'yaml'
require 'terminal-table'
require 'i18n'
require 'colorize'

cars_db = YAML.safe_load(File.read(CARS_PATH), permitted_classes: [Symbol])

car_print = ConsolePrint.new(cars_db, I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
                             [I18n.t(:INDEX).colorize(:yellow), I18n.t(:VALUE).colorize(:yellow)])
puts car_print.printing_to_console

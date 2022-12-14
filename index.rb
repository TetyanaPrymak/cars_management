# frozen_string_literal: true

require 'yaml'
require 'terminal-table'
require 'i18n'
require 'colorize'

MENU_INPUTS = %w[1 2 3 4].freeze
LANG_LIST = %w[en ua].freeze
DEFAULT_LANGUAGE = :en
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
menu_item = 3

I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.default_locale = :en

def print_message(key)
  puts I18n.t(key)
end

print_message(:welcome)
user_lang = gets.chomp

I18n.locale = LANG_LIST.include?(user_lang) ? user_lang.to_sym : DEFAULT_LANGUAGE

while menu_item.to_i != 4
  menu_table = Terminal::Table.new headings: [I18n.t(:menu_head1), I18n.t(:menu_head2)], title: I18n.t(:menu_title),
                                   rows: I18n.t(:menu_items), style: { width: 80, padding_left: 3, border_x: '=',
                                                                       border_i: 'x', all_separators: true }
  puts menu_table
  print_message(:menu_start)
  menu_item = gets.chomp

  case
  when menu_item.to_i == 1
    load 'cars/car_search.rb'
  when menu_item.to_i == 2
    load 'cars/all_cars.rb'
  when menu_item.to_i == 3
    print_message(:help)
  when menu_item.to_i == 4
    print_message(:exit)
  else
    menu_item = 3
  end
end

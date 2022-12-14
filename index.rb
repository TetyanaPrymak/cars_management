# frozen_string_literal: true

require 'yaml'
require 'terminal-table'
require 'i18n'
require 'colorize'

MENU_INPUTS = %w[1 2 3 4].freeze
LANG_LIST = %w[en ua].freeze
DEFAULT_LANGUAGE = :en
menu_item = 3

puts 'Please choose language (en | ua): '
user_lang = gets.chomp
I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.default_locale = :en

I18n.locale = LANG_LIST.include?(user_lang) ? user_lang.to_sym : DEFAULT_LANGUAGE

def help_assistant
  puts I18n.t(:help)
end

while menu_item.to_i != 4
  menu_table = Terminal::Table.new headings: [I18n.t(:menu_head1), I18n.t(:menu_head2)], title: I18n.t(:menu_title),
                                   rows: I18n.t(:menu_items), style: { width: 80, padding_left: 3, border_x: '=',
                                                                       border_i: 'x', all_separators: true }
  puts menu_table
  puts I18n.t(:menu_start)
  menu_item = gets.chomp

  case
  when menu_item.to_i == 1
    load 'cars/car_search.rb'
  when menu_item.to_i == 2
    load 'cars/all_cars.rb'
  when menu_item.to_i == 3
    help_assistant
  when menu_item.to_i == 4
    puts I18n.t(:exit)
  else
    puts 'Please choose item from menu'
    menu_item = 3
  end
end

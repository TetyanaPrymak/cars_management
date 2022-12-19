# frozen_string_literal: true

require 'yaml'
require 'terminal-table'
require 'i18n'
require 'colorize'
require_relative 'searches/all_cars'
require_relative 'searches/car_search'
require_relative 'menu_option'
require_relative 'userlang'

MENU_INPUTS = %w[1 2 3 4].freeze

class ConsolePrint
  attr_accessor :data, :table_title, :table_heading

  def initialize(data, table_title, table_heading)
    @data = data
    @table_title = table_title
    @table_heading = table_heading
  end

  def printing_to_console
    Terminal::Table.new title: @table_title, headings: @table_heading do |t|
      @data.each do |car|
        car.each do |key, value|
          rows = [key, value]
          t.add_row rows
          t.style = { width: 80, border_bottom: false, padding_left: 3, border_x: '=', border_i: 'x' }
        end
        t << :separator
      end
    end
  end
end

class Menu
  attr_accessor :menu_item

  def initialize
    menu_table = ConsolePrint.new(I18n.t(:menu_items), I18n.t(:menu_title), [I18n.t(:menu_head1), I18n.t(:menu_head2)])
    puts menu_table.printing_to_console
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
  end

  def user_choice
    case
    when @menu_item == 1
      CarSearch.new.run
    when @menu_item == 2
      AllCars.new.run
    when @menu_item == 3
      print_message(:help)
    when @menu_item == 4
      print_message(:exit)
    else @menu_item = 3 end
  end
end

I18n.locale = UserLang.new.user_lang

user_menu = Menu.new
user_menu.user_choice
menu_item = user_menu.menu_item

while menu_item != 4
  user_menu = Menu.new
  user_menu.user_choice
  menu_item = user_menu.menu_item
end

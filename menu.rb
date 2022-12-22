# frozen_string_literal: true

require_relative 'prepare_console_output'
require_relative 'searches/all_cars'
require_relative 'searches/car_search'

class Menu
  include MessagePrinter
  attr_accessor :menu_item

  MENUINPUTS = [1, 2, 3, 4].freeze

  def initialize
    menu_table_printer = PrepareConsoleOutput.new(
      I18n.t(:menu_items), I18n.t(:menu_title),
      [
        I18n.t(:menu_head1), I18n.t(:menu_head2)
      ]
    )
    puts menu_table_printer.call
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
  end

  def call
    case
    when @menu_item == MENUINPUTS[0]
      CarSearch.new.call
    when @menu_item == MENUINPUTS[1]
      AllCars.new.call
    when @menu_item == MENUINPUTS[2]
      print_message(:help)
    when @menu_item == MENUINPUTS[3]
      print_message(:exit)
    else @menu_item = MENUINPUTS[2] end
  end
end

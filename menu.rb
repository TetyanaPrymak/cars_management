# frozen_string_literal: true

require_relative 'searches/all_cars'
require_relative 'searches/car_search'

class Menu
  include MessagePrinter
  attr_accessor :menu_item

  def initialize
    menu_table_printer = ConsolePrint.new(I18n.t(:menu_items), I18n.t(:menu_title),
                                          [I18n.t(:menu_head1), I18n.t(:menu_head2)])
    puts menu_table_printer.call
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
  end

  def call
    case
    when @menu_item == 1
      CarSearch.new.call
    when @menu_item == 2
      AllCars.new.call
    when @menu_item == 3
      print_message(:help)
    when @menu_item == 4
      print_message(:exit)
    else @menu_item = 3 end
  end
end

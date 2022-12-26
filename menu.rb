# frozen_string_literal: true

require 'bcrypt'
require_relative 'prepare_console_output'
require_relative 'searches/all_cars'
require_relative 'searches/car_search'
require_relative 'users/user_signup'
require_relative 'users/user_signin'
require_relative 'users/user_verification'

class Menu
  include MessagePrinter
  attr_accessor :menu_item, :menu_items, :user_signin, :signed

  MENUINPUTS = [1, 2, 3, 4, 5, 6].freeze

  def initialize
    @signed = false
    @menu_items = :menu_items_in
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
    when @menu_item == MENUINPUTS[4]
      menu_in_out
    when @menu_item == MENUINPUTS[5]
      UserSignup.new.call
    else @menu_item = MENUINPUTS[2] end
  end

  def menu_table_in_out
    @signed = signed
    @menu_items = menu_items
    menu_table_printer = PrepareConsoleOutput.new(
      I18n.t(@menu_items), I18n.t(:menu_title),
      [
        I18n.t(:menu_head1), I18n.t(:menu_head2)
      ]
    )
    puts menu_table_printer.call
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
  end

  def menu_in_out
    if @signed == true
      menu_out
    else
      menu_in
    end
  end

  def menu_in
    @user_signin = UserSignin.new
    @user_signin.call
    @signed = @user_signin.signed
    @menu_items = @user_signin.menu_items
  end

  def menu_out
    @signed = false
    @menu_items = :menu_items_out
    print_message(:exit)
    print_message(:menu_start)
    user_menu = Menu.new
    user_menu.menu_table_in_out
    user_menu.call
    @menu_item = user_menu.menu_item
    end
end

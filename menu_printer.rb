# frozen_string_literal: true

require_relative 'prepare_console_output'
require_relative 'menu'
require_relative 'users/user_signup'
require_relative 'users/user_signin'
require_relative 'message_printer'

class MenuPrinter
  include MessagePrinter
  attr_accessor :menu_item, :menu_items, :user_signin, :signed, :user_menu

  def initialize
    @signed = signed
    @menu_items = menu_items
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

  def call(signed)
    @menu_items = signed ? :menu_items_out : :menu_items_in
    menu_table_printer = PrepareConsoleOutput.new(
      I18n.t(@menu_items), I18n.t(:menu_title),
      [
        I18n.t(:menu_head1), I18n.t(:menu_head2)
      ]
    )
    puts menu_table_printer.call
  end
end

# frozen_string_literal: true

require_relative 'prepare_console_output'
require_relative 'menu'
require_relative 'users/user_signup'
require_relative 'users/user_signin'
require_relative 'message_printer'

class MenuPrinter
  include MessagePrinter
  attr_accessor :menu_items, :signed, :admin

  def initialize
    @signed = signed
    @menu_items = menu_items
    @admin = admin
  end

  def call(signed, admin)
    if admin
      @menu_items = :admin_menu_items
    else
      @menu_items = signed ? :menu_items_out : :menu_items_in
    end
    menu_table_printer = PrepareConsoleOutput.new(
      I18n.t(@menu_items), I18n.t(:menu_title),
      [
        I18n.t(:menu_head1), I18n.t(:menu_head2)
      ]
    )
    puts menu_table_printer.call
  end
end

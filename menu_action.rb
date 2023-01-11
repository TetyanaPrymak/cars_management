# frozen_string_literal: true

require 'bcrypt'
require_relative 'menu_printer'
require_relative 'users/user_signin'
require_relative 'menu'
require_relative 'admin_menu'

class MenuAction
  attr_accessor :menu_item, :signed, :user_signin, :user_menu, :menu_items, :admin_menu_item, :admin

  def initialize
    @menu_item = 0
    @admin_menu_item = 0
  end

  def call
    @user_menu = Menu.new
    @admin = @user_menu.admin
    while @menu_item != 4 && @admin == false
      @signed = @user_menu.signed || false
      @admin = @user_menu.admin
      MenuPrinter.new.call(@signed, @admin)
      @user_menu.call
      @menu_item = user_menu.menu_item
      @admin = @user_menu.admin
    end
    while @menu_item != 4 && @admin == true
      @signed = @user_menu.signed || false
      @admin = @user_menu.admin
      @admin_menu = AdminMenu.new
      MenuPrinter.new.call(@signed, @admin)
      @admin_menu.call
      @menu_item = @admin_menu.menu_item
      @admin = @user_menu.admin
    end
  end
end

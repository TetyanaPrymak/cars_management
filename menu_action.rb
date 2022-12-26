# frozen_string_literal: true

require 'bcrypt'
require_relative 'users/user_signin'

class MenuAction
  attr_accessor :menu_item, :signed, :user_signin, :user_menu, :menu_items

  def initialize
    @menu_item = 0
  end

  def call
    user_menu = Menu.new
    while @menu_item != 4
      user_menu.menu_table_in_out
      user_menu.call
      @menu_item = user_menu.menu_item
    end
  end
end

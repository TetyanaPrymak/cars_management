# frozen_string_literal: true

class MenuAction
  attr_accessor :menu_item

  def initialize
    @menu_item = 0
  end

  def call
    while @menu_item != 4
      user_menu = Menu.new
      user_menu.call
      @menu_item = user_menu.menu_item
    end
  end
end

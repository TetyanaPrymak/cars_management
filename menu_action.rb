
# frozen_string_literal: true

class MenuAction < Menu
  attr_accessor :menu_item
  def initialize
    @menu_item = 0
  end

  def action
    while @menu_item != 4
      user_menu = Menu.new
      user_menu.user_choice
      @menu_item = user_menu.menu_item
    end
  end
end

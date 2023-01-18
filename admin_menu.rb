# frozen_string_literal: true

require 'bcrypt'
require_relative 'prepare_console_output'
require_relative 'searches/all_cars'
require_relative 'searches/car_search'
require_relative 'users/user_signup'
require_relative 'users/user_signin'
require_relative 'users/user_search'
require_relative 'menu_printer'
require_relative 'advertising/ads_create'
require_relative 'advertising/ads_delete'
require_relative 'advertising/ads_update'

class AdminMenu
  include MessagePrinter
  attr_accessor :menu_item, :menu_items, :user_signin, :signed, :email

  ADMININPUTS = [1, 2, 3, 4].freeze

  def initialize
    @signed = false
    @menu_items = :admin_menu_items
    @admin = false
  end

  def call
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
    case
    when @menu_item == ADMININPUTS[0]
      AdsCreate.new.call
    when @menu_item == ADMININPUTS[1]
      AdsUpdate.new.call
    when @menu_item == ADMININPUTS[2]
      AdsDelete.new.call
    when @menu_item == ADMININPUTS[3]
      print_message(:exit_for_user)
      @signed = false
      @admin = false
      MenuAction.new.call
    else @menu_item = 0 end
  end
end

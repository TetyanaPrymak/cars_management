# frozen_string_literal: true

require 'bcrypt'
require_relative 'prepare_console_output'
require_relative 'searches/all_cars'
require_relative 'searches/car_search'
require_relative 'users/user_signup'
require_relative 'users/user_signin'
require_relative 'users/user_search'
require_relative 'menu_printer'

class Menu
  include MessagePrinter
  attr_accessor :menu_item, :menu_items, :user_signin, :signed, :email, :admin

  MENUINPUTS = [1, 2, 3, 4, 5, 6].freeze

  def initialize
    @signed = false
    @menu_items = :menu_items_in
    @admin = false
  end

  def call
    print_message(:menu_start)
    @menu_item = gets.chomp.to_i
    case
    when @menu_item == MENUINPUTS[0]
      @email = @signed ? @email : 'not_signed'
      CarSearch.new(@email).call
    when @menu_item == MENUINPUTS[1]
      AllCars.new.call
    when @menu_item == MENUINPUTS[2]
      print_message(:help)
    when @menu_item == MENUINPUTS[3]
      print_message(:exit)
    when @menu_item == MENUINPUTS[4]
      menu_in_out
    when @menu_item == MENUINPUTS[5]
      menu_up_mysearches
    else @menu_item = MENUINPUTS[2] end
  end

  def menu_in_out
    if @signed == false
      @user_signin = UserSignin.new
      @user_signin.call
      @signed = @user_signin.signed
      @admin = @user_signin.admin
      @email = @user_signin.email
    else
      print_message(:exit_for_user)
      @signed = false
      @admin = false
    end
  end

  def menu_up_mysearches
    if @signed == false
      @user_signup = UserSignup.new
      @user_signup.call
      @signed = @user_signup.signed
      @email = @user_signup.email
    else
      @user_search = UserSearch.new(@email)
      @user_search.find_user
      @user_search.call
    end
  end
end

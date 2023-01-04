# frozen_string_literal: true

require 'date'
require 'colorize'
require_relative 'user_signin'
require_relative 'user_signup'
require_relative '../searches/car_search'

class UserSearch
  include MessagePrinter
  attr_accessor :user_searches, :email, :user_my_searches

  USERS_SEARCHES_PATH = 'user_searches.yml'

  def initialize(email)
    @email = email
    @users_searches = YamlLoad.new(USERS_SEARCHES_PATH).data
  end

  def find_user
    if @users_searches.key?(@email)
      @user_my_searches = @users_searches[@email]
    else
      @user_my_searches = []
    end
  end

  def call
    find_user
    if @user_my_searches.length.positive?
      print_my_search
    else
      print_message(:zero_searches)
    end
  end

  def print_my_search
    my_searches_print = PrepareConsoleOutput.new(
      user_my_searches,
      I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
      [
        I18n.t(:INDEX).colorize(:yellow),
        I18n.t(:VALUE).colorize(:yellow)
      ]
    )
    puts my_searches_print.call
  end
end

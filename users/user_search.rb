# frozen_string_literal: true

require 'date'
require 'colorize'
require_relative 'user_signin'
require_relative 'user_signup'
require_relative '../searches/car_search'

class UserSearch
  include MessagePrinter
  attr_accessor :searches_archive, :email, :user_my_searches

  SEARCHES_PATH = 'searches.yml'

  def initialize(email)
    @email = email
    @searches_archive = YamlLoad.new(SEARCHES_PATH).data
  end

  def find_user
    user_results = searches_archive.keep_if { |key, value| value[:Search_users].include?(@email) }
    @user_my_searches = []
    @user_my_searches = user_results.keys
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

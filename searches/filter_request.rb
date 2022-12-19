# frozen_string_literal: true

class FilterRequest
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :sort_option, :sort_direction

  BY_PRICE = 'price'
  BY_DATE_ADDED = 'date_added'
  DIRECTION = 'desc'

  def initialize
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
    @sort_option = sort_option
    @sort_direction = sort_direction
  end

  def text_input?(user_input)
    user_input =~ /\D/
  end

  def can_capitalize?(user_input)
    user_input =~ /^[A-Za-z].*/
  end

  def text_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    if can_capitalize?(user_input)
      user_input.capitalize!
    end
    rule == 'make' ? @make = user_input : @model = user_input
  end

  def year_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    year = text_input?(user_input) ? '' : user_input
    rule == 'year_from' ? @year_from = year : @year_to = year
  end

  def price_rules(rule)
    rule_localized = I18n.t(rule)
    print_message(:option_request)
    print " #{rule_localized}: "
    user_input = gets.chomp
    price = text_input?(user_input) ? '' : user_input
    rule == 'price_from' ? @price_from = price : @price_to = price
  end

  def sort_rules
    print_message(:sorting_request)
    sort_option = gets.chomp
    @sort_option = sort_option == I18n.t(:price) ? BY_PRICE : BY_DATE_ADDED
    print_message(:direction_request)
    sort_direction = gets.chomp
    @sort_direction = sort_direction == I18n.t(:direction) ? 'asc' : DIRECTION
  end
end

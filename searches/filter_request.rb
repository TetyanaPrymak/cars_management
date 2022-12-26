# frozen_string_literal: true

require_relative 'user_input'

class FilterRequest < UserInput
  include MessagePrinter
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to

  def initialize
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
  end

  def text_input?(user_input)
    user_input =~ /\D/
  end

  def can_capitalize?(user_input)
    user_input =~ /^[A-Za-z].*/
  end

  def text_rules(rule, message)
    user_input = UserInput.new(rule, message).user_input
    if can_capitalize?(user_input)
      user_input.capitalize!
    end
    rule == 'make' ? @make = user_input : @model = user_input
  end

  def year_rules(rule, message)
    user_input = UserInput.new(rule, message).user_input
    year = text_input?(user_input) ? '' : user_input
    rule == 'year_from' ? @year_from = year : @year_to = year
  end

  def price_rules(rule, message)
    user_input = UserInput.new(rule, message).user_input
    price = text_input?(user_input) ? '' : user_input
    rule == 'price_from' ? @price_from = price : @price_to = price
  end
end

# frozen_string_literal: true

require_relative 'user_input'

class SortRequest < UserInput
  include MessagePrinter
  attr_accessor :sort_option, :sort_direction

  BY_PRICE = 'price'
  BY_DATE_ADDED = 'date_added'
  DIRECTION = 'desc'

  def initialize
    @sort_option = sort_option
    @sort_direction = sort_direction
  end

  def text_input?(user_input)
    user_input =~ /\D/
  end

  def call(rule, message)
    user_input = UserInput.new(rule, message).user_input
    if rule == 'sorting_request'
      option = user_input
      @sort_option = option == I18n.t(:price) ? BY_PRICE : BY_DATE_ADDED
    else
      direction = user_input
      @sort_direction = direction == I18n.t(:direction) ? 'asc' : DIRECTION
    end
  end
end

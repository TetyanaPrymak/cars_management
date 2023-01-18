# frozen_string_literal: true

require 'bcrypt'
require_relative '../yaml_load'

class AdsValidator
  include MessagePrinter
  attr_accessor :users_db

  def make_model_validated?(ads_text_input)
    ads_text_input =~ /([a-z]{3,50})/i
  end

  def year_validated?(year_input)
    (year_input.to_s =~ /^[0-9]*$/) && (year_input.to_i <= Date.today.year) && (year_input.to_i >= 1900)
  end

  def odometer_price_validated?(number_input)
    (number_input.to_s =~ /^[0-9]*$/) && (number_input.to_i >= 0)
  end

  def description_validated?(description_input)
    if description_input.nil?
      return true
    elsif description_input.length <= 5000
      return true
    else
      return false
    end
  end
end

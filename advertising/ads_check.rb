# frozen_string_literal: true

require 'bcrypt'
require 'securerandom'
require_relative 'ads_validator'

class AdsCheck
  include MessagePrinter
  attr_accessor :ads_car, :make_validated, :model_validated, :year_validated, :odometer_validated, :price_validated,
                :description_validated

  def initialize
    @ads_car = {}
    @ads_validator = AdsValidator.new
  end

  def validate_ads_make(ads_make)
    if @ads_validator.make_model_validated?(ads_make)
      @ads_car['make'] = ads_make
      @make_validated = true
    else
      print_message(:element_error)
      print_message(:make)
      print_message(:make_error)
      @make_validated = false
    end
  end

  def validate_ads_model(ads_model)
    if @ads_validator.make_model_validated?(ads_model)
      @ads_car['model'] = ads_model
      @model_validated = true
    else
      print_message(:element_error)
      print_message(:model)
      print_message(:model_error)
      @model_validated = false
    end
  end

  def validate_ads_year(ads_year)
    if @ads_validator.year_validated?(ads_year)
      @ads_car['year'] = ads_year.to_i
      @year_validated = true
    else
      print_message(:element_error)
      print_message(:year)
      print_message(:year_error)
      @year_validated = false
    end
  end

  def validate_ads_odometer(ads_odometer)
    if @ads_validator.odometer_price_validated?(ads_odometer)
      @ads_car['odometer'] = ads_odometer.to_i
      @odometer_validated = true
    else
      print_message(:element_error)
      print_message(:odometer)
      print_message(:odometer_error)
      @odometer_validated = false
    end
  end

  def validate_ads_price(ads_price)
    if @ads_validator.odometer_price_validated?(ads_price)
      @ads_car['price'] = ads_price.to_i
      @price_validated = true
    else
      print_message(:element_error)
      print_message(:price)
      print_message(:price_error)
      @price_validated = false
    end
  end

  def validate_ads_description(ads_description)
    if @ads_validator.description_validated?(ads_description)
      @ads_car['description'] = ads_description
      @description_validated = true
    else
      print_message(:description_error)
      @ads_car['description'] = ''
      @description_validated = true
    end
  end

  def ads_elements_validated?
    valid = make_validated && model_validated && year_validated && odometer_validated && price_validated &&
            description_validated
    if valid
      return true
    else
      return false
    end
  end
end

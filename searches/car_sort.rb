# frozen_string_literal: true

require 'yaml'
require 'date'
require 'terminal-table'
require 'i18n'
require 'colorize'
require_relative '../user_lang'
require_relative '../yaml_load'

class CarSort
  attr_accessor :cars_db, :sort_option, :sort_direction

  def initialize(car_filter, cars_db)
    car_filter.sort_rules
    @sort_option = car_filter.sort_option
    @sort_direction = car_filter.sort_direction
    @cars_db = cars_db
  end

  def date_convert
    cars_db.each do |car_db|
      car_db['date_added'] = Date.strptime(car_db['date_added'], '%d/%m/%y')
    end
  end

  def sorting
    if sort_direction == 'asc'
      cars_db.sort! { |car1, car2| car1[sort_option] <=> car2[sort_option] }
    else
      cars_db.sort! { |car1, car2| car2[sort_option] <=> car1[sort_option] }
    end
  end

  def call
    date_convert
    sorting
  end
end

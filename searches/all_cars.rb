# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'
require_relative '../message_printer'

class AllCars
  include MessagePrinter
  CARS_PATH = 'cars.yml'
  def call
    cars_db = YamlLoad.new(CARS_PATH).data

    car_print = PrepareConsoleOutput.new(
      cars_db,
      I18n.t(:SEARCH_RESULTS).colorize(:light_blue),
      [
        I18n.t(:INDEX).colorize(:yellow),
        I18n.t(:VALUE).colorize(:yellow)
      ]
    )
    puts car_print.call
  end
end

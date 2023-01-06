# frozen_string_literal: true

require 'yaml'
require 'ffaker'
require 'securerandom'
require_relative 'yaml_load'

class CarsAdd
  def initialize
    @id = SecureRandom.uuid
    @make = FFaker::Vehicle.make
    @model = FFaker::Vehicle.model
    @year = FFaker::Vehicle.year.to_i
    @odometer = FFaker::Random.rand(1000..200_000)
    @price = FFaker::Random.rand(1000..30_000)
    @description = FFaker::Vehicle.interior_upholstery
    @date_added = Time.now.strftime('%d/%m/%y')
  end

  def to_hash
    { 'id': @id, 'make': @make, 'model': @model, 'year': @year, 'odometer': @odometer,
      'price': @price, 'description': @description, 'date_added': @date_added }
  end
end

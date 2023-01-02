# frozen_string_literal: true

class CarFilter < FilterRequest
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to

  RULES_MAKE_MODEL = %w[make model].freeze
  RULES_YEAR = %w[year_from year_to].freeze
  RULES_PRICE = %w[price_from price_to].freeze

  def initialize(email)
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
    @email = email
  end

  def equal?(user_input, db_value)
    (user_input.empty? || user_input.casecmp?(db_value))
  end

  def between?(user_input_from, user_input_to, db_value)
    (user_input_from.empty? || user_input_from.to_i <= db_value) &&
      (user_input_to.empty? || user_input_to.to_i >= db_value)
  end

  def car_matches?(car_db)
    equal?(@make, car_db['make']) &&
      equal?(@model, car_db['model']) &&
      between?(@year_from, @year_to, car_db['year']) &&
      between?(@price_from, @price_to, car_db['price'])
  end

  def to_archive
    { 'make': @make, 'model': @model, 'year_from': @year_from, 'year_to': @year_to,
      'price_from': @price_from, 'price_to': @price_to }
  end
end

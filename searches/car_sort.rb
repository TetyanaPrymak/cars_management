# frozen_string_literal: true

require_relative 'sort_request'

class CarSort < SortRequest
  attr_accessor :sort_option, :sort_direction

  def initialize
    @sort_option = sort_option
    @sort_direction = sort_direction
  end

  def sorting(cars_db)
    if sort_direction == 'asc'
      cars_db.sort! { |car1, car2| car1[sort_option] <=> car2[sort_option] }
    else
      cars_db.sort! { |car1, car2| car2[sort_option] <=> car1[sort_option] }
    end
  end
end

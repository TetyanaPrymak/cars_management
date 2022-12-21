# frozen_string_literal: true

require 'terminal-table'
require_relative 'searches/all_cars'
require_relative 'searches/filter_request'
require_relative 'searches/car_search'
require_relative 'user_lang'

class ConsolePrint
  attr_accessor :data, :table_title, :table_heading

  def initialize(data, table_title, table_heading)
    @data = data
    @table_title = table_title
    @table_heading = table_heading
  end

  def call
    Terminal::Table.new title: @table_title, headings: @table_heading do |t|
      @data.each do |item|
        item.each do |key, value|
          rows = [key, value]
          t.add_row rows
          t.style = { width: 80, border_bottom: false, padding_left: 3, border_x: '=', border_i: 'x' }
        end
        t << :separator
      end
    end
  end
end

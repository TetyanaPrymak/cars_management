# frozen_string_literal: true

require_relative '../menu_option'
require_relative '../user_lang'
require_relative '../yaml_load'

class CarsArchive
  attr_accessor :search, :searches_archive, :cars_total

  def initialize(search, searches_archive, cars_total)
    @search = search
    @searches_archive = searches_archive
    @cars_total = cars_total
  end

  def write_to_archive
    if @searches_archive.key?(@search)
      search_number = @searches_archive[@search][:Requests]
      search_number += 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total }
    else
      search_number = 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total }
    end
  end
end

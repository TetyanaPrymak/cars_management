# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'

class CarsArchive
  def initialize(search, searches_archive, cars_total)
    @search = search
    @searches_archive = searches_archive
    @cars_total = cars_total
  end

  def call
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

# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'

class CarsArchive
  attr_accessor :search, :searches_archive, :cars_total

  def initialize(search, searches_archive, cars_total, email)
    @search = search
    @searches_archive = searches_archive
    @cars_total = cars_total
  end

  def call_no_user
    if @searches_archive.key?(@search)
      search_users = @searches_archive[@search][:Search_users]
      search_number = @searches_archive[@search][:Requests]
      search_number += 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total, Search_users: search_users }
    else
      search_users = []
      search_number = 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total, Search_users: search_users }
    end
  end

  def call_with_user(email)
    if @searches_archive.key?(@search)
      search_users = @searches_archive[@search][:Search_users]
      unless search_users.include?(email)
        search_users.push(email)
      end
      search_number = @searches_archive[@search][:Requests]
      search_number += 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total, Search_users: search_users }
    else
      search_users = [email]
      search_number = 1
      @searches_archive[@search] = { Requests: search_number, Total: @cars_total, Search_users: search_users }
    end
  end
end

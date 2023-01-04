# frozen_string_literal: true

require_relative '../user_lang'
require_relative '../yaml_load'

class UsersArchive
  def initialize(email, car_to_archive, users_searches)
    @car_to_archive = car_to_archive
    @email = email
    @users_searches = users_searches
  end

  def put_user_search
    if @users_searches.nil?
      @users_searches = []
      user_searches = []
      user_searches.push(@car_to_archive)
      user_search = { email: user_searches }
      @users_searches.push(user_search)
    elsif @users_searches.key?(@email)
      user_searches = @users_searches[@email]
      unless user_searches.include?(@car_to_archive)
        user_searches.push(@car_to_archive)
      end
      @users_searches[@email] = user_searches
    else
      user_searches = []
      user_searches.push(@car_to_archive)
      @users_searches[@email] = user_searches
    end
  end
end

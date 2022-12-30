# frozen_string_literal: true

require 'bcrypt'
require_relative '../yaml_load'

class PasswordValidator
  include MessagePrinter
  attr_accessor :users_db

  USERS_PATH = 'users/users.yml'

  def initialize
    @users_db = YamlLoad.new(USERS_PATH).data || []
  end

  def password_validated?(password_input)
    password_input =~ /^(?=.*[A-Z])(?=.*[`!@#$%^&*-_=+'.,]{2})(?!.*\s).{8,20}$/
  end

  def password_matches?(email, password)
    found = users_db.find_index { |user_db| user_db.value?(email) }
    if found.nil?
      return false
    elsif users_db[found][:password] == password
      return true
    else
      return false
    end
  end
end

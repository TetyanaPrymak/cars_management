# frozen_string_literal: true

require 'bcrypt'
require_relative '../yaml_load'

class EmailValidator
  include MessagePrinter
  attr_accessor :users_db

  USERS_PATH = 'users/users.yml'

  def initialize
    @users_db = YamlLoad.new(USERS_PATH).data || []
  end

  def email_validated?(email_input)
    email_input =~ /\A([^@\s]{5,}+)@((?:[-a-z0-9]{2,}+\.)+[a-z]{2,})\z/i
  end

  def user_present?(email_input)
    found = users_db.any? { |user_db| user_db.value?(email_input) }
    return found
  end
end

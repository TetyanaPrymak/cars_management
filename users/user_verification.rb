# frozen_string_literal: true

require 'bcrypt'
require_relative '../yaml_load'
require_relative 'user_verification'

class UserVerification
  include MessagePrinter
  attr_accessor :users_db, :signed

  USERS_PATH = 'users/users.yml'

  def initialize
    @signedn = signed
    @menu_items = menu_items
    @users_db = users_db
   end

  def email_validated?(email_input)
    email_input =~ /\A([^@\s]{5,}+)@((?:[-a-z0-9]{2,}+\.)+[a-z]{2,})\z/i
  end

  def password_validated?(password_input)
    password_input =~ /^(?=.*[A-Z])(?=.*[`!@#$%^&*-_=+'.,]{2})(?!.*\s).{8,20}$/
  end

  def user_present?(email_input)
    found = users_db.find_index{ |user_db| user_db.value?(email_input) }
    return false if found.nil?
    return true if found >= 0
  end

  def password_matches?(email, password)
    found = users_db.find_index{ |user_db| user_db.value?(email) }
    if found.nil?
      @signed = false
    elsif users_db[found][:password] == @password
      @signed = true
    else
      @signed = false
    end
  end
end

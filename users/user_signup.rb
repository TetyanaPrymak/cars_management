# frozen_string_literal: true

require 'bcrypt'
require_relative 'email_validator'
require_relative 'password_validator'

class UserSignup
  include MessagePrinter
  attr_accessor :email, :password, :signed

  USERS_PATH = 'users/users.yml'

  def initialize
    @email_validator = EmailValidator.new
    @password_validator = PasswordValidator.new
    @users_db = YamlLoad.new(USERS_PATH).data || []
  end

  def call
    read_email
    validate_email_password
    write_email_password
  end

  def read_email
    print_message(:email_request)
    email_input = gets.chomp
    if @email_validator.email_validated?(email_input)
      @email = email_input
      if @email_validator.user_present?(@email)
        print_message(:unique_error)
        @email_verified = false
      else
        @email_verified = true
      end
    else
      @email_verified = false
    end
  end

  def validate_email_password
    if @email_verified == false
      print_message(:email_error)
      @password_verified = false
    else
      print_message(:password_request)
      password_input = gets.chomp
      if @password_validator.password_validated?(password_input)
        @password = password_input
        @password_verified = true
      else
        print_message(:password_error)
        @password_verified = false
      end
    end
  end

  def write_email_password
    if @password_verified == false && @email_verified == true
      print_message(:email_mismatch)
      @signed = false
    elsif @password_verified == false && @email_verified == false
      print_message(:signup_error)
      @signed = false
    else
      @signed = true
      print_message(:hello)
      puts "#{@email}!"
      password_bycript = BCrypt::Password.create(@password)
      user = { email: @email, password: password_bycript.to_s }
      @users_db.push(user)
      File.open(USERS_PATH, 'w') { |file| file.write(@users_db.to_yaml) }
    end
  end
end

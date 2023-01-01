# frozen_string_literal: true

require 'bcrypt'
require_relative 'email_validator'
require_relative 'password_validator'

class UserSignin
  include MessagePrinter
  attr_accessor :email, :password, :signed

  def initialize
    @email_validator = EmailValidator.new
    @password_validator = PasswordValidator.new
  end

  def call
    read_email
    validate_email_password
    match_email_password
  end

  def read_email
    print_message(:email_request)
    email_input = gets.chomp
    if @email_validator.email_validated?(email_input)
      @email = email_input
      @email_verified = true
    else
      @email_verified = false
    end
  end

  def validate_email_password
    if @email_verified == false
      print_message(:email_error)
      @password_verified = false
    elsif @email_validator.user_present?(@email)
      print_message(:password_request)
      password_input = gets.chomp
      if @password_validator.password_validated?(password_input)
        @password = password_input
        @password_verified = true
      else
        @password_verified = false
      end
    else
      print_message(:email_mismatch)
      @password_verified = false
    end
  end

  def match_email_password
    if @password_validator.password_matches?(@email, @password)
      @signed = true
      puts I18n.t(:hello)
      puts "#{@email}!"
    else
      print_message(:password_mismatch)
      @signed = false
    end
  end
end

# frozen_string_literal: true

require 'bcrypt'
require_relative 'user_verification'

class UserSignup < UserVerification
  include MessagePrinter
  attr_accessor :email, :password, :signed, :menu_items

  def initialize
    @signed = signed
    @menu_items = menu_items
    @email = email
    @password = password
    @signed = false
    @menu_items = :menu_items_in
    @users_db = YamlLoad.new(USERS_PATH).data
  end

  def call
    read_email
    validate_email_password
    write_email_password
  end

  def read_email
    print_message(:email_request)
    email_input = gets.chomp
    @email = email_validated?(email_input) ? email_input : ''
  end

  def validate_email_password
    if @email == ''
      print_message(:email_error)
    elsif user_present?(@email)
      print_message(:unique_error)
    else
      print_message(:password_request)
      password_input = gets.chomp
      @password = password_validated?(password_input) ? password_input : ''
    end
  end

  def write_email_password
    if @password == ''
      print_message(:password_error)
    elsif @password.nil?
      print_message(:signup_error)
    else
      @signed = true
      @menu_items = :menu_items_out
      print_message(:hello)
      puts "#{@email} !"
      password_bycript = BCrypt::Password.create(@password)
      user = { email: @email, password: password_bycript }
      @users_db << user
      File.open(USERS_PATH, 'w') { |file| file.write(@users_db.to_yaml) }
    end
  end
end

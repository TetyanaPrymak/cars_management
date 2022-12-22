# frozen_string_literal: true

class UserInput
  include MessagePrinter
  attr_accessor :user_input

  def initialize(rule, message)
    print_message(message)
    rule_localized = I18n.t(rule)
    print " #{rule_localized}: "
    @user_input = gets.chomp
  end
end

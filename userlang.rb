# frozen_string_literal: true

require 'i18n'
require 'colorize'

LANG_LIST = %w[en ua].freeze
DEFAULT_LANGUAGE = :en
I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.default_locale = :en

class UserLang
  attr_accessor :user_lang

  def initialize
    puts I18n.t(:welcome)
    user_lang = gets.chomp
    I18n.locale = LANG_LIST.include?(user_lang) ? user_lang.to_sym : DEFAULT_LANGUAGE
    @user_lang = I18n.locale
  end
end

def print_message(key)
  puts I18n.t(key)
end

# frozen_string_literal: true

require_relative 'menu'
require_relative 'user_lang'
require_relative 'menu_action'
require_relative 'users/user_signin'

I18n.locale = UserLang.new.user_lang

MenuAction.new.call

# frozen_string_literal: true

require_relative 'menu'
require_relative 'menu_option'
require_relative 'user_lang'
require_relative 'menu_action'

I18n.locale = UserLang.new.user_lang

MenuAction.new.action

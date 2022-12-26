# frozen_string_literal: true

require 'i18n'

module MessagePrinter
  def print_message(key)
    puts I18n.t(key)
  end
end

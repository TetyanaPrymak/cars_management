# frozen_string_literal: true


require 'bcrypt'
require 'yaml'
require 'i18n'

class YamlLoad
  attr_reader :path, :data

  def initialize(file_path)
    @data = YAML.safe_load(File.read(file_path), permitted_classes: [Symbol, BCrypt::Password]) || {}
  end
end

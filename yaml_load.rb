# frozen_string_literal: true

require 'yaml'
require 'i18n'

CARS_PATH = 'cars.yml'
SEARCHES_PATH = 'searches.yml'

class YamlLoad
  attr_reader :path, :data

  def initialize(file_path)
    @data = YAML.safe_load(File.read(file_path), permitted_classes: [Symbol]) || {}
  end
end

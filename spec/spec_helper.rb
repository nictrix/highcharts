require 'rspec'
require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

require File.dirname(__FILE__) + '/../lib/highcharts'
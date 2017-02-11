require_relative 'test_helper'

require 'capybara'
require 'capybara-screenshot/minitest'

# Directory for capybara-screenshot
Capybara.save_path = '/tmp'

ENV['RACK_ENV'] = 'test'

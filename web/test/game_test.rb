ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/dsl'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    Capybara.app = Sinatra::Application.new
  end

  def test_it_works
    visit '/'
    assert page.has_content?('Yahtzee')
  end
end

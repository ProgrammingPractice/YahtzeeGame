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

  def test_complete_game
    visit '/'
    assert has_content?('Yahtzee')
    assert has_content?('Please enter number of players:')

    select('1', from: 'players_count')
    click_button('Submit')
    assert has_content?('Playing -> Player 1')

    check('checkbox_dice_0')
    check('checkbox_dice_2')
    click_button('Submit')
  end
end

ENV['RACK_ENV'] = 'test'

require 'capybara'
require 'capybara/dsl'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../app'
require 'capybara-screenshot/minitest'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    Capybara.app = Sinatra::Application.new
  end

  def test_complete_game
    visit '/new_game'
    assert_equal 200, status_code
    assert has_content?('Yahtzee')
    assert has_content?('Please enter number of players:')

    select('2', from: 'players_count')
    click_button('Start game')
    assert_equal 200, status_code
    assert has_content?('Player 1: 0 points')
    assert has_content?('Player 2: 0 points')

    assert has_content?('Playing -> Player 1')
    assert has_content?('You rolled:')
    assert has_content?('roll 1/3')

    check('checkbox_dice_0')
    check('checkbox_dice_2')
    click_button('Submit')

    assert_equal 200, status_code
    assert has_content?('roll 2/3')

    check('checkbox_dice_3')
    check('checkbox_dice_4')
    click_button('Submit')

    assert_equal 200, status_code
    assert has_content?('roll 3/3')
    refute has_content?('Select what to hold:')

    choose('radiobutton_category_chance')
    click_button('Select category')

    assert_equal 200, status_code
    refute has_content?('Player 1: 0 points')
    assert has_content?('Player 2: 0 points')
  end
end

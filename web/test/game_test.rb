require_relative 'capybara_helper'

require_relative '../lib/game'
require_relative '../../test/fake_dice_roller'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    @dice_roller = FakeDiceRoller.new
    application = Sinatra::Application.new
    application.settings.set(:dice_roller, @dice_roller)
    Capybara.app = application
  end

  def the_dice_will_be(dice)
    @dice_roller.add_values(dice)
  end

  def test_complete_game
    visit '/new_game'
    assert_equal 200, status_code
    assert has_content?('Yahtzee')
    assert has_content?('Please enter number of players:')

    the_dice_will_be([1,2,3,4,5])

    select('2', from: 'players_count')
    click_button('Start game')
    assert_equal 200, status_code
    assert has_content?('Player 1: 0 points')
    assert has_content?('Player 2: 0 points')

    assert has_content?('Playing -> Player 1')
    assert has_content?('You rolled: [1, 2, 3, 4, 5]')
    assert has_content?('roll 1/3')

    the_dice_will_be([1,1,1,1,1])

    check('checkbox_dice_0')
    check('checkbox_dice_1')
    check('checkbox_dice_2')
    check('checkbox_dice_3')
    check('checkbox_dice_4')
    click_button('Submit')

    assert_equal 200, status_code
    assert has_content?('roll 2/3')

    the_dice_will_be([1,2,3,4,5])

    check('checkbox_dice_3')
    check('checkbox_dice_4')
    click_button('Submit')

    assert_equal 200, status_code
    assert has_content?('roll 3/3')
    refute has_content?('Select what to hold:')

    the_dice_will_be([2,2,2,2,2])

    choose('radiobutton_category_chance')
    click_button('Select category')

    assert_equal 200, status_code
    assert has_content?('Player 1: 15 points')
    assert has_content?('Player 2: 0 points')
  end
end

require_relative 'capybara_helper'

require_relative '../lib/yahtzee_web'
require_relative '../../test/fake_dice_roller'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    @dice_roller = FakeDiceRoller.new
    application = YahtzeeWeb.new
    application.settings.set(:dice_roller, @dice_roller)
    Capybara.app = application

    # We need to set this so that capybara-screenshot works
    Sinatra::Application.root = application.settings.root
  end

  def test_complete_game
    the_dice_will_be([1,2,3,4,5])
    start_new_game_with_players(2)
    assert has_content?('You rolled: [1, 2, 3, 4, 5]')

    the_dice_will_be([1,1,1,1,1])
    player_holds_dice_in_round('Player 1', [], 1)
    assert has_content?('You rolled: [1, 1, 1, 1, 1]')

    the_dice_will_be([1,2,3])
    player_holds_dice_in_round('Player 1', [3,4], 2)
    assert has_content?('You rolled: [1, 2, 3, 1, 1]')

    the_dice_will_be([2,2,2,2,2])
    player_selects_category('Player 1', 'chance')
    assert has_content?('You rolled: [2, 2, 2, 2, 2]')

    assert has_content?('Player 1: 8 points')
    assert has_content?('Player 2: 0 points')

    player_holds_dice_in_round('Player 2', [0,1,2,3,4], 1)
    assert has_content?('You rolled: [2, 2, 2, 2, 2]')

    the_dice_will_be([1,2,3,4,5])
    player_selects_category('Player 2', 'twos')

    assert has_content?('Player 1: 8 points')
    assert has_content?('Player 2: 10 points')
  end

  def start_new_game_with_players(count)
    visit '/new_game'
    assert_equal 200, status_code
    assert has_content?('Yahtzee')
    assert has_content?('Please enter number of players:')

    select(count.to_s, from: 'players_count')
    click_button('Start game')
    assert_equal 200, status_code
    assert has_content?('Player 1: 0 points')
    assert has_content?('Player 2: 0 points')
  end

  def player_holds_dice_in_round(player_name, positions_to_hold, round_number)
    assert has_content?("Playing -> #{player_name}")
    assert has_content?("roll #{round_number}/3")

    positions_to_hold.each do |p|
      check("checkbox_dice_#{p}")
    end

    click_button('Submit')

    assert_equal 200, status_code
  end

  def player_selects_category(player_name, category)
    assert has_content?("Playing -> #{player_name}")
    refute has_content?('Select what to hold:')

    choose("radiobutton_category_#{category}")
    click_button('Select category')

    assert_equal 200, status_code
  end

  def the_dice_will_be(dice)
    unless @dice_roller.empty?
      raise "FakeDiceRoller is not empty but you are trying to add new values!"
    end
    @dice_roller.add_values(dice)
  end
end

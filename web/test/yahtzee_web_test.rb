require_relative 'capybara_helper'

require 'yahtzee_web'
require 'helpers/test_data'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    @test_data   = TestData.new
    @dice_roller = FakeDiceRoller.new([], @test_data)
    Capybara.app = YahtzeeWeb.new(@dice_roller)

    # We need to set this so that capybara-screenshot works
    Sinatra::Application.root = Capybara.app.settings.root
  end

  def test_complete_game
    start_new_game_with_players(@test_data.players_count)

    # IDEA:
    # while @test_data.turns_left do
    @test_data.turns_count.times do |turn_index|
      player_holds_dice_from_roll(1)
      player_holds_dice_from_roll(2) if @test_data.player_rolled_again?
      player_selects_category
      check_score
      @dice_roller.ensure_exact_use_of_dice

      # IDEA:
      # advance_to_next_turn unless @test_data.last_turn?
      if turn_index < @test_data.turns_count - 1
        advance_to_next_turn
      end
    end

    assert_has_content?("#{@test_data.winner_name} won with #{@test_data.winner_score} points!")
  end

  def start_new_game_with_players(count)
    visit '/new_game'
    assert_equal 200, status_code
    assert_has_content?('Yahtzee')
    assert_has_content?('Please enter number of players:')

    select(count.to_s, from: 'players_count')
    click_button('Start game')
    assert_equal 200, status_code
    assert_has_content?('Player 1: 0 points')
    assert_has_content?('Player 2: 0 points')
  end

  def player_holds_dice_from_roll(roll_number)
    assert_has_content?("Playing -> #{@test_data.current_player_name}")
    assert_has_content?("roll #{roll_number}/3")

    @test_data.next_hold_positions.each do |p|
      check("checkbox_dice_#{p}")
    end

    click_button('Submit')

    assert_equal 200, status_code
  end

  def player_selects_category
    assert_has_content?("Playing -> #{@test_data.current_player_name}")
    refute has_content?('Select what to hold:')

    choose("radiobutton_category_#{@test_data.extract_category}")
    click_button('Select category')

    assert_equal 200, status_code
  end

  def check_score
    assert_has_content?("#{@test_data.current_player_name}: #{@test_data.extract_score} points")
  end

  def advance_to_next_turn
    @test_data.advance_to_next_player
    @dice_roller.move_to_next_group
    click_link('Advance to next player')
  end

  private

  def assert_has_content?(content)
    assert has_content?(content), "Could not find content: #{content.inspect}"
  end
end

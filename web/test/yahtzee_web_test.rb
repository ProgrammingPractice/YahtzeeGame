require_relative 'capybara_helper'

require 'yahtzee_web'
require 'helpers/test_data'

class YahtzeeWebTest < Minitest::Test
  include Capybara::DSL

  def setup
    @dice_roller = FakeDiceRoller.new
    application = YahtzeeWeb.new(@dice_roller)
    Capybara.app = application

    # We need to set this so that capybara-screenshot works
    Sinatra::Application.root = application.settings.root

    file_path = File.expand_path('../../core/test/fixtures/complete_game.json', __dir__)
    json = JSON.parse(File.read(file_path))
    @test_data = TestData.new(json, @dice_roller)
  end

  def test_complete_game
    start_new_game_with_players(@test_data.players_count)

    30.times do |i|
      hold_positions = @test_data.next_hold_positions

      player_holds_dice_from_roll(
        @test_data.current_player,
        hold_positions,
        1
      )

      if hold_positions.size < 5
        player_holds_dice_from_roll(
          @test_data.current_player,
          @test_data.next_hold_positions,
          2
        )
      end

      player_selects_category(
        @test_data.current_player,
        @test_data.extract_category
      )

      @dice_roller.ensure_exact_use_of_dice

      the_score_should_be(
        @test_data.current_player,
        @test_data.extract_score
      )

      if i < 29
        @test_data.advance_to_next_player
        click_link('Advance to next player')
      end
    end

    assert_has_content?('Player 2 won with 75 points!')
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

  def player_holds_dice_from_roll(player_name, positions_to_hold, roll_number)
    assert_has_content?("Playing -> #{player_name}")
    assert_has_content?("roll #{roll_number}/3")

    positions_to_hold.each do |p|
      check("checkbox_dice_#{p}")
    end

    click_button('Submit')

    assert_equal 200, status_code
  end

  def player_selects_category(player_name, category)
    assert_has_content?("Playing -> #{player_name}")
    refute has_content?('Select what to hold:')

    choose("radiobutton_category_#{category}")
    click_button('Select category')

    assert_equal 200, status_code
  end

  def the_score_should_be(player_name, expected_score)
    assert_has_content?("#{player_name}: #{expected_score} points")
  end

  def the_dice_will_be(dice)
    @dice_roller.add_values_for_round(dice)
  end

  def assert_has_content?(content)
    assert has_content?(content), "Could not find content: #{content.inspect}"
  end
end

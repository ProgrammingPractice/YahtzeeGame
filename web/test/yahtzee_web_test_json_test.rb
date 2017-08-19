require_relative 'capybara_helper'

require 'yahtzee_web'
require 'helpers/test_data'

class YahtzeeWebJsonTest < Minitest::Test
  include Capybara::DSL

  def setup
    @dice_roller = FakeDiceRoller.new
    application = YahtzeeWeb.new(@dice_roller)
    Capybara.app = application

    # We need to set this so that capybara-screenshot works
    Sinatra::Application.root = application.settings.root

    json = JSON.parse(File.read('../core/test/fixtures/complete_game.json'))
    @test_data = TestData.new(json, @dice_roller)
  end

  def test_complete_game
    start_new_game_with_players(@test_data.players_count)

    player_holds_dice_in_round(
      @test_data.current_player,
      @test_data.next_hold_positions,
      1
    )
    player_holds_dice_in_round(
      @test_data.current_player,
      @test_data.next_hold_positions,
      2
    )
    player_selects_category(
      @test_data.current_player,
      @test_data.extract_category
    )
  end

  # def test_complete_game

  #   players = test_data.player_names.map do |name|
  #     Player.new(name, dice_roller)
  #   end
  #   game = Game.new(players)
  #   game_wrapper = GameWrapper.new(game)
  #   ui = FakeUI.new(game_wrapper, self, test_data, dice_roller)

  #   ui.run

  #   assert_equal "Player 1 won with 75 points!", ui.output.last
  # end

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

  def player_holds_dice_in_round(player_name, positions_to_hold, round_number)
    assert_has_content?("Playing -> #{player_name}")
    assert_has_content?("roll #{round_number}/3")

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

  def the_dice_will_be(dice)
    @dice_roller.add_values_for_round(dice)
  end

  def assert_has_content?(content)
    assert has_content?(content), "Could not find content: #{content.inspect}"
  end
end

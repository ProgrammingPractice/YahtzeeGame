require_relative 'test_helper'
require_relative '../lib/yahtzee_game'

class IntegrationTest < Minitest::Test
  def test_integration_between_yahtzee_game_and_dice_roller
    game = YahtzeeGame.new
    assert 5, game.roll_dice.size
  end
end

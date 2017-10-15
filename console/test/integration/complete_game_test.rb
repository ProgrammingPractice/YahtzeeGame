require_relative '../test_helper'
require 'json'

require 'ui'
require 'helpers/fake_ui'
require 'helpers/test_data'

class CompleteGameTest < Minitest::Test
  def test_complete_game
    test_data = TestData.new
    dice_roller = test_data.dice_roller

    players = test_data.player_names.map do |name|
      Player.new(name, dice_roller)
    end
    game = Game.new(players)
    game_wrapper = GameWrapper.new(game)
    ui = FakeUI.new(game_wrapper, self, test_data)

    ui.run

    assert_equal "#{test_data.winner_name} won with #{test_data.winner_score} points!", ui.output.last
  end
end

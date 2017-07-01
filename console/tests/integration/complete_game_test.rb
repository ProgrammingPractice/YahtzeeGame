require_relative '../test_helper'
require 'json'

require 'ui'
require 'helpers/fake_ui'
require 'helpers/test_data'

class CompleteGameTest < Minitest::Test
  def test_complete_game
    json = JSON.parse(File.read('tests/fixtures/complete_game.json'))

    dice_roller = FakeDiceRoller.new([])

    test_data = TestData.new(json, dice_roller)

    players = test_data.player_names.map do |name|
      Player.new(name, dice_roller)
    end
    game = Game.new(players)
    game_wrapper = GameWrapper.new(game)
    ui = FakeUI.new(game_wrapper, self, test_data, dice_roller)

    ui.run

    assert_equal "Player 1 won with 75 points!", ui.output.last
  end
end

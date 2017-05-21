require_relative '../test_helper'
require 'json'

require 'helpers/fake_ui'
require 'helpers/test_data'

class CompleteGameTest < Minitest::Test
  def test_complete_game
    json = JSON.parse(File.read('tests/fixtures/complete_game.json'))
    rounds_p0 = json['rounds_p0']
    rounds_p1 = json['rounds_p1']

    dice_roller = FakeDiceRoller.new([])
    player0     = Player.new('Player 0', dice_roller)
    player1     = Player.new('Player 1', dice_roller)
    game        = Game.new([player0, player1])

    rounds = {
      player0.name => rounds_p0,
      player1.name => rounds_p1,
    }

    test_data = TestData.new(rounds)

    ui           = FakeUI.new(self, test_data, dice_roller)
    game_wrapper = GameWrapper.new(game)

    ui.run(game_wrapper)
    assert_equal "Player 1 won with 75 points!", ui.output.last
  end
end

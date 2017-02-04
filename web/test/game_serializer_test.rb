require 'minitest/autorun'
require 'minitest/pride'

require_relative '../lib/game_serializer'
require_relative '../../lib/game'
require_relative '../../lib/player'
require_relative '../../lib/dice_roller'

class GameSerializerTest < Minitest::Test
  def test_serialize_and_deserialize_game
    orig_player1 = Player.new('Player 1', nil)
    orig_player1.instance_variable_set(:@score, 25)
    orig_player1.instance_variable_set(:@categories, ['yahtzee'])

    orig_player2 = Player.new('Player 2', nil)
    orig_player2.instance_variable_set(:@score, 30)
    orig_player2.instance_variable_set(:@categories, ['ones', 'threes'])

    orig_game = Game.new([orig_player1, orig_player2])

    data = GameSerializer.dump(orig_game)
    assert_equal String, data.class

    game = GameSerializer.load(data)
    assert_equal Game, game.class

    player1 = game.players[0]
    assert_equal 'Player 1', player1.name
    assert_equal 25, player1.score
    assert_equal ['yahtzee'], player1.categories

    player2 = game.players[1]
    assert_equal 'Player 2', player2.name
    assert_equal 30, player2.score
    assert_equal ['ones', 'threes'], player2.categories
  end
end

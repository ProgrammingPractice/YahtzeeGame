require_relative 'test_helper'
require_relative '../lib/multiplayer'

class MultiplayerTest < Minitest::Test
  def test_game_with_two_players_each_have_their_own_score_and_categories
    game = Multiplayer.new(2)
    p1 = game.players[0]
    p2 = game.players[1]

    p1.roll_dice
    p1.place_in_category_and_calculate_score('chance')

    refute_equal 0, p1.score
    refute p1.categories.include?('chance')

    assert_equal 0, p2.score
    assert p2.categories.include?('chance')
  end
end

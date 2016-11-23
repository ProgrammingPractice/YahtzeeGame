require_relative 'test_helper'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def test_game_with_two_players_each_have_their_own_score_and_categories
    game = Game.new(2)
    p1 = game.players[0]
    p2 = game.players[1]

    p1.roll_dice
    p1.place_in_category_and_calculate_score('chance')

    refute_equal 0, p1.score
    refute p1.categories.include?('chance')

    assert_equal 0, p2.score
    assert p2.categories.include?('chance')
  end

  def test_rounds_left_returns_true_as_long_as_the_game_is_not_over
    game = Game.new(1)
    assert game.rounds_left?

    player = game.players.first
    player.roll_dice
    ScoreCalculator::CATEGORIES.each do |category|
      player.place_in_category_and_calculate_score(category)
    end
    refute game.rounds_left?
  end
end

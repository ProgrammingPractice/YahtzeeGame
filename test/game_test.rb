require_relative 'test_helper'
require_relative '../lib/game'

class GameTest < Minitest::Test
  def test_game_with_two_players_each_have_their_own_score_and_categories
    game = Game.new(2)
    p1 = game.players[0]
    p2 = game.players[1]

    p1.roll_dice
    p1.select_category('chance')

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
      player.select_category(category)
    end
    refute game.rounds_left?
  end

  def test_winner_returns_the_player_with_highest_score
    roller = FakeDiceRoller.new([2,2,2,2,2, 1,2,3,4,5])
    game = Game.new(2, roller)
    p1 = game.players[0]
    p2 = game.players[1]

    p1.roll_dice
    p1.select_category('yahtzee')
    p2.roll_dice
    p2.select_category('chance')

    assert_equal p1, game.winner
  end

  def test_winner_returns_all_the_players_with_highest_score
    skip
    roller = FakeDiceRoller.new([2,2,2,2,2, 2,2,2,2,2])
    game = Game.new(2, roller)
    p1 = game.players[0]
    p2 = game.players[1]

    p1.roll_dice
    p1.select_category('yahtzee')
    p2.roll_dice
    p2.select_category('yahtzee')

    assert_equal [p1,p2], game.winner
  end
end

require_relative 'test_helper'

class GameTest < Minitest::Test
  def test_game_with_two_players_each_have_their_own_score_and_categories
    dice_roller = DiceRoller.new
    p1 = Player.new('p1', dice_roller)
    p2 = Player.new('p2', dice_roller)
    game = Game.new([p1, p2])

    p1.roll_dice
    p1.select_category('chance')

    refute_equal 0, p1.score
    refute p1.categories.include?('chance')

    assert_equal 0, p2.score
    assert p2.categories.include?('chance')
  end

  def test_rounds_left_returns_true_as_long_as_the_game_is_not_over
    dice_roller = DiceRoller.new
    player = Player.new('p', dice_roller)
    game = Game.new([player])
    assert game.rounds_left?

    player.roll_dice
    ScoreCalculator::CATEGORIES.each do |category|
      player.select_category(category)
    end
    refute game.rounds_left?
  end

  def test_winners_returns_all_the_players_with_highest_score
    dice_roller = FakeDiceRoller.new([2,2,2,2,2, 2,2,2,2,2, 1,2,3,4,5])
    p1 = Player.new('p1', dice_roller)
    p2 = Player.new('p2', dice_roller)
    p3 = Player.new('p3', dice_roller)
    game = Game.new([p1, p2, p3])

    p1.roll_dice
    p1.select_category('yahtzee')
    p2.roll_dice
    p2.select_category('yahtzee')
    p3.roll_dice
    p3.select_category('chance')

    assert_equal [p1,p2], game.winners
  end
end

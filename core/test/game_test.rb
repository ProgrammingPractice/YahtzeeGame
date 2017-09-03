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

  def test_finished_returns_true_when_last_player_finished_his_categories
    dice_roller = DiceRoller.new
    player0     = Player.new('Player 0', dice_roller, ['yahtzee'])
    player1     = Player.new('Player 1', dice_roller, ['yahtzee'])
    game        = Game.new([player0, player1])

    player0.roll_dice; player0.select_category('yahtzee')
    refute game.finished?

    player1.roll_dice; player1.select_category('yahtzee')
    assert game.finished?
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

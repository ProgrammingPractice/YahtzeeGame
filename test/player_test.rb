require_relative 'test_helper'
require_relative '../lib/player'

class PlayerTest < Minitest::Test
  class FakeDiceRoller
    def initialize(values)
      @values = values
    end

    def roll_one
      @values.shift
    end

    def add_values(values)
      @values.concat(values)
    end
  end

  def test_complete_round
    player_rolls([1,2,3,4,1])
    player_holds([0,4])
    player_rerolls([1,2,3]) # => [1,1,2,3,1]
    player_holds([0,1,4])
    player_rerolls([2,1])   # => [1,1,2,1,1]
    player_selects_category('ones')

    assert the_category_is_no_longer_available('ones')
    assert_equal 4, the_score
  end

  def test_roll_dice_performs_a_random_roll_and_saves_it_on_the_game
    roller = FakeDiceRoller.new [1,2,3,4,5]
    player = Player.new(roller)
    player.roll_dice
    assert_equal [1,2,3,4,5], player.roll
  end

  def test_reroll_rolls_again_the_dice_from_the_specified_positions
    roller = FakeDiceRoller.new [1,2,3,4,5,4,5,6]
    player = Player.new(roller)
    player.roll_dice
    player.reroll([0,2,4])
    assert_equal [4,2,5,4,6], player.roll
  end

  def test_categories_lists_the_available_categories
    player = Player.new
    assert_equal ScoreCalculator::CATEGORIES, player.categories

    player.roll_dice
    player.place_in_category_and_calculate_score('yahtzee')
    assert_equal ScoreCalculator::CATEGORIES - ['yahtzee'], player.categories
  end

  def test_place_in_category_and_calculate_score
    roller = FakeDiceRoller.new [1,2,3,4,5]
    player = Player.new(roller)
    player.roll_dice
    assert_equal 15, player.place_in_category_and_calculate_score('chance')
  end

  def test_score_initially_is_zero
    player = Player.new
    assert_equal 0, player.score
  end

  def test_score_keeps_track_of_multiple_rounds
    roller = FakeDiceRoller.new [1,2,3,4,5,1,1,1,1,1]
    player = Player.new(roller)

    player.roll_dice
    player.place_in_category_and_calculate_score('chance')
    assert_equal 15, player.score

    player.roll_dice
    player.place_in_category_and_calculate_score('yahtzee')
    assert_equal 65, player.score
  end

  private

  def player_rolls(roll)
    @roller = FakeDiceRoller.new roll
    @player = Player.new(@roller)
    @player.roll_dice
  end

  def player_holds(positions)
    @hold_positions = positions
  end

  def player_rerolls(partial_roll)
    @roller.add_values partial_roll
    reroll_positions = [0,1,2,3,4] - @hold_positions
    @player.reroll(reroll_positions)
  end

  def player_selects_category(category)
    @player.place_in_category_and_calculate_score(category)
  end

  def the_category_is_no_longer_available(category)
    !@player.categories.include?(category)
  end

  def the_score
    @player.score
  end
end

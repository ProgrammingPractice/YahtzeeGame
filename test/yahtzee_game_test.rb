gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'

require_relative '../lib/yahtzee_game'

class YahtzeeGameTest < Minitest::Test
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

    player_sees_that_category_is_no_longer_available('ones')
    player_gets_score(4)
  end

  def test_roll_dice_performs_a_random_roll_and_saves_it_on_the_game
    roller = FakeDiceRoller.new [1,2,3,4,5]
    game = YahtzeeGame.new(roller)
    game.roll_dice
    assert_equal [1,2,3,4,5], game.roll
  end

  def test_reroll_rolls_again_the_dice_from_the_specified_positions
    roller = FakeDiceRoller.new [1,2,3,4,5,4,5,6]
    game = YahtzeeGame.new(roller)
    game.roll_dice
    game.reroll([0,2,4])
    assert_equal [4,2,5,4,6], game.roll
  end

  def test_categories_lists_the_available_categories
    categories = [
      'Chance',
      'Yahtzee',
      'Ones',
      'Twos',
      'Threes',
      'Fours',
      'Fives',
      'Sixes',
      'Pair',
      'Two pairs',
      'Three of a kind',
      'Four of a kind',
      'Small straight',
      'Large straight',
      'Full house',
    ]

    game = YahtzeeGame.new
    assert_equal categories, game.categories

    game.roll_dice
    game.place_in_category_and_calculate_score('yahtzee')
    assert_equal categories - ['Yahtzee'], game.categories
  end

  def test_place_in_category_and_calculate_score
    roller = FakeDiceRoller.new [1,2,3,4,5]
    game = YahtzeeGame.new(roller)
    game.roll_dice
    assert_equal 15, game.place_in_category_and_calculate_score('chance')
  end

  def test_score_initially_is_zero
    game = YahtzeeGame.new
    assert_equal 0, game.score
  end

  def test_score_keeps_track_of_multiple_rounds
    roller = FakeDiceRoller.new [1,2,3,4,5,1,1,1,1,1]
    game = YahtzeeGame.new(roller)

    game.roll_dice
    game.place_in_category_and_calculate_score('chance')
    assert_equal 15, game.score

    game.roll_dice
    game.place_in_category_and_calculate_score('yahtzee')
    assert_equal 65, game.score
  end

  private

  def player_rolls(roll)
    @roller = FakeDiceRoller.new roll
    @game = YahtzeeGame.new(@roller)
    @game.roll_dice
  end

  def player_holds(positions)
    @hold_positions = positions
  end

  def player_rerolls(partial_roll)
    @roller.add_values partial_roll
    reroll_positions = [0,1,2,3,4] - @hold_positions
    @game.reroll(reroll_positions)
  end

  def player_selects_category(category)
    @game.place_in_category_and_calculate_score(category)
  end

  def player_sees_that_category_is_no_longer_available(category)
    assert !@game.categories.map(&:downcase).include?(category)
  end

  def player_gets_score(expected)
    assert_equal expected, @game.score
  end
end

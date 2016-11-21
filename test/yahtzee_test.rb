gem 'minitest', '>= 5.0.0'
require 'minitest/autorun'

require_relative '../lib/yahtzee'

class YahtzeeTest < Minitest::Test
  def test_calculate_score_with_unknown_category
    assert_raises ArgumentError do
      Yahtzee.calculate_score("some_category", [1,2,3,4,5])
    end
  end

  def test_chance
    assert_equal 5,  Yahtzee.calculate_score('chance', [1,1,1,1,1])
    assert_equal 15, Yahtzee.calculate_score('chance', [1,2,3,4,5])
    assert_equal 30, Yahtzee.calculate_score('chance', [6,6,6,6,6])
  end

  def test_yahtzee
    assert_equal 0,  Yahtzee.calculate_score('yahtzee', [2,2,4,2,2])
    assert_equal 50, Yahtzee.calculate_score('yahtzee', [2,2,2,2,2])
    assert_equal 50, Yahtzee.calculate_score('yahtzee', [5,5,5,5,5])
  end

  def test_ones
    assert_equal 0, Yahtzee.calculate_score('ones', [2,2,2,2,2])
    assert_equal 3, Yahtzee.calculate_score('ones', [1,2,2,1,1])
    assert_equal 5, Yahtzee.calculate_score('ones', [1,1,1,1,1])
  end

  def test_twos
    assert_equal 0, Yahtzee.calculate_score('twos', [1,1,1,1,1])
    assert_equal 2, Yahtzee.calculate_score('twos', [1,2,1,1,1])
    assert_equal 8, Yahtzee.calculate_score('twos', [1,2,2,2,2])
  end

  def test_threes
    assert_equal 0, Yahtzee.calculate_score('threes', [2,2,4,5,6])
    assert_equal 3, Yahtzee.calculate_score('threes', [2,3,4,5,6])
    assert_equal 9, Yahtzee.calculate_score('threes', [2,3,3,3,6])
  end

  def test_fours
    assert_equal 0,  Yahtzee.calculate_score('fours', [2,2,3,5,6])
    assert_equal 4,  Yahtzee.calculate_score('fours', [2,3,4,5,6])
    assert_equal 12, Yahtzee.calculate_score('fours', [4,3,4,3,4])
  end

  def test_fives
    assert_equal 0,  Yahtzee.calculate_score('fives', [2,2,3,6,6])
    assert_equal 5,  Yahtzee.calculate_score('fives', [2,3,4,5,6])
    assert_equal 10, Yahtzee.calculate_score('fives', [4,5,4,5,4])
  end

  def test_sixes
    assert_equal 0,  Yahtzee.calculate_score('sixes', [2,2,3,5,5])
    assert_equal 6,  Yahtzee.calculate_score('sixes', [2,3,4,5,6])
    assert_equal 18, Yahtzee.calculate_score('sixes', [4,6,6,6,4])
  end

  def test_pair
    assert_equal 0,  Yahtzee.calculate_score('pair', [2,3,4,5,6])
    assert_equal 0,  Yahtzee.calculate_score('pair', [2,2,2,2,6])
    assert_equal 2,  Yahtzee.calculate_score('pair', [1,2,3,4,1])
    assert_equal 4,  Yahtzee.calculate_score('pair', [2,2,4,5,6])
    assert_equal 12, Yahtzee.calculate_score('pair', [1,1,6,6,5])
  end

  def test_two_pairs
    assert_equal 0, Yahtzee.calculate_score('two_pairs', [1,2,3,4,5])
    assert_equal 0, Yahtzee.calculate_score('two_pairs', [1,1,2,3,4])
    assert_equal 0, Yahtzee.calculate_score('two_pairs', [1,1,4,4,4])
    assert_equal 8, Yahtzee.calculate_score('two_pairs', [1,1,2,3,3])
  end

  def test_three_of_a_kind
    assert_equal 0, Yahtzee.calculate_score('three_of_a_kind', [3,3,4,5,6])
    assert_equal 0, Yahtzee.calculate_score('three_of_a_kind', [3,3,3,3,4])
    assert_equal 9, Yahtzee.calculate_score('three_of_a_kind', [3,3,3,4,5])
  end

  def test_four_of_a_kind
    assert_equal 0, Yahtzee.calculate_score('four_of_a_kind', [2,2,2,4,4])
    assert_equal 0, Yahtzee.calculate_score('four_of_a_kind', [2,2,2,2,2])
    assert_equal 8, Yahtzee.calculate_score('four_of_a_kind', [2,2,2,2,4])
  end

  def test_small_straight
    assert_equal 0,  Yahtzee.calculate_score('small_straight', [2,3,4,5,6])
    assert_equal 15, Yahtzee.calculate_score('small_straight', [5,4,3,2,1])
    assert_equal 15, Yahtzee.calculate_score('small_straight', [1,2,3,4,5])
  end

  def test_large_straight
    assert_equal 0,  Yahtzee.calculate_score('large_straight', [1,2,3,4,5])
    assert_equal 20, Yahtzee.calculate_score('large_straight', [6,5,4,3,2])
    assert_equal 20, Yahtzee.calculate_score('large_straight', [2,3,4,5,6])
  end

  def test_full_house
    assert_equal 0, Yahtzee.calculate_score('full_house', [1,2,3,4,5])
    assert_equal 0, Yahtzee.calculate_score('full_house', [1,1,2,3,4])
    assert_equal 0, Yahtzee.calculate_score('full_house', [1,1,2,2,3])
    assert_equal 0, Yahtzee.calculate_score('full_house', [1,1,1,2,3])
    assert_equal 0, Yahtzee.calculate_score('full_house', [4,4,4,4,4])
    assert_equal 8, Yahtzee.calculate_score('full_house', [1,1,2,2,2])
  end
end
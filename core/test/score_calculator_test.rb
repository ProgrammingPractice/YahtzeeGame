require_relative 'test_helper'

class ScoreCalculatorTest < Minitest::Test
  def test_list_of_categories
    expected = [
      'chance',
      'yahtzee',
      'ones',
      'twos',
      'threes',
      'fours',
      'fives',
      'sixes',
      'pair',
      'two_pairs',
      'three_of_a_kind',
      'four_of_a_kind',
      'small_straight',
      'large_straight',
      'full_house',
    ]
    assert_equal expected, ScoreCalculator::CATEGORIES
  end

  def test_all_categories_have_an_implementation
    ScoreCalculator::CATEGORIES.each do |category|
      ScoreCalculator.calculate(category, [1,2,3,4,5])
    end
  end

  def test_calculate_with_unknown_category
    assert_raises ArgumentError do
      ScoreCalculator.calculate("some_category", [1,2,3,4,5])
    end
  end

  def test_chance
    assert_equal 5,  ScoreCalculator.calculate('chance', [1,1,1,1,1])
    assert_equal 15, ScoreCalculator.calculate('chance', [1,2,3,4,5])
    assert_equal 30, ScoreCalculator.calculate('chance', [6,6,6,6,6])
  end

  def test_yahtzee
    assert_equal 0,  ScoreCalculator.calculate('yahtzee', [2,2,4,2,2])
    assert_equal 50, ScoreCalculator.calculate('yahtzee', [2,2,2,2,2])
    assert_equal 50, ScoreCalculator.calculate('yahtzee', [5,5,5,5,5])
  end

  def test_ones
    assert_equal 0, ScoreCalculator.calculate('ones', [2,2,2,2,2])
    assert_equal 3, ScoreCalculator.calculate('ones', [1,2,2,1,1])
    assert_equal 5, ScoreCalculator.calculate('ones', [1,1,1,1,1])
  end

  def test_twos
    assert_equal 0, ScoreCalculator.calculate('twos', [1,1,1,1,1])
    assert_equal 2, ScoreCalculator.calculate('twos', [1,2,1,1,1])
    assert_equal 8, ScoreCalculator.calculate('twos', [1,2,2,2,2])
  end

  def test_threes
    assert_equal 0, ScoreCalculator.calculate('threes', [2,2,4,5,6])
    assert_equal 3, ScoreCalculator.calculate('threes', [2,3,4,5,6])
    assert_equal 9, ScoreCalculator.calculate('threes', [2,3,3,3,6])
  end

  def test_fours
    assert_equal 0,  ScoreCalculator.calculate('fours', [2,2,3,5,6])
    assert_equal 4,  ScoreCalculator.calculate('fours', [2,3,4,5,6])
    assert_equal 12, ScoreCalculator.calculate('fours', [4,3,4,3,4])
  end

  def test_fives
    assert_equal 0,  ScoreCalculator.calculate('fives', [2,2,3,6,6])
    assert_equal 5,  ScoreCalculator.calculate('fives', [2,3,4,5,6])
    assert_equal 10, ScoreCalculator.calculate('fives', [4,5,4,5,4])
  end

  def test_sixes
    assert_equal 0,  ScoreCalculator.calculate('sixes', [2,2,3,5,5])
    assert_equal 6,  ScoreCalculator.calculate('sixes', [2,3,4,5,6])
    assert_equal 18, ScoreCalculator.calculate('sixes', [4,6,6,6,4])
  end

  def test_pair
    assert_equal 0,  ScoreCalculator.calculate('pair', [2,3,4,5,6])
    assert_equal 0,  ScoreCalculator.calculate('pair', [2,2,2,2,6])
    assert_equal 2,  ScoreCalculator.calculate('pair', [1,2,3,4,1])
    assert_equal 4,  ScoreCalculator.calculate('pair', [2,2,4,5,6])
    assert_equal 12, ScoreCalculator.calculate('pair', [1,1,6,6,5])
  end

  def test_two_pairs
    assert_equal 0, ScoreCalculator.calculate('two_pairs', [1,2,3,4,5])
    assert_equal 0, ScoreCalculator.calculate('two_pairs', [1,1,2,3,4])
    assert_equal 0, ScoreCalculator.calculate('two_pairs', [1,1,4,4,4])
    assert_equal 8, ScoreCalculator.calculate('two_pairs', [1,1,2,3,3])
  end

  def test_three_of_a_kind
    assert_equal 0, ScoreCalculator.calculate('three_of_a_kind', [3,3,4,5,6])
    assert_equal 0, ScoreCalculator.calculate('three_of_a_kind', [3,3,3,3,4])
    assert_equal 9, ScoreCalculator.calculate('three_of_a_kind', [3,3,3,4,5])
  end

  def test_four_of_a_kind
    assert_equal 0, ScoreCalculator.calculate('four_of_a_kind', [2,2,2,4,4])
    assert_equal 0, ScoreCalculator.calculate('four_of_a_kind', [2,2,2,2,2])
    assert_equal 8, ScoreCalculator.calculate('four_of_a_kind', [2,2,2,2,4])
  end

  def test_small_straight
    assert_equal 0,  ScoreCalculator.calculate('small_straight', [2,3,4,5,6])
    assert_equal 15, ScoreCalculator.calculate('small_straight', [5,4,3,2,1])
    assert_equal 15, ScoreCalculator.calculate('small_straight', [1,2,3,4,5])
  end

  def test_large_straight
    assert_equal 0,  ScoreCalculator.calculate('large_straight', [1,2,3,4,5])
    assert_equal 20, ScoreCalculator.calculate('large_straight', [6,5,4,3,2])
    assert_equal 20, ScoreCalculator.calculate('large_straight', [2,3,4,5,6])
  end

  def test_full_house
    assert_equal 0, ScoreCalculator.calculate('full_house', [1,2,3,4,5])
    assert_equal 0, ScoreCalculator.calculate('full_house', [1,1,2,3,4])
    assert_equal 0, ScoreCalculator.calculate('full_house', [1,1,2,2,3])
    assert_equal 0, ScoreCalculator.calculate('full_house', [1,1,1,2,3])
    assert_equal 0, ScoreCalculator.calculate('full_house', [4,4,4,4,4])
    assert_equal 8, ScoreCalculator.calculate('full_house', [1,1,2,2,2])
  end
end
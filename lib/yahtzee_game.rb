require_relative 'yahtzee'
require_relative 'dice_roller'

class YahtzeeGame
  attr_reader :categories
  attr_reader :roll
  attr_reader :score

  CATEGORIES = [
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
    'Full house'
  ]

  def initialize(dice_roller = DiceRoller.new)
    @score = 0
    @dice_roller = dice_roller
    @categories = CATEGORIES.dup
  end

  def roll_dice
    @roll = (1..5).map { @dice_roller.roll_one }
  end

  def reroll(positions)
    positions.each do |position|
      @roll[position] = @dice_roller.roll_one
    end
  end

  def place_in_category_and_calculate_score(category)
    @categories.delete(category.capitalize)
    @score += Yahtzee.send(category, roll)
  end
end

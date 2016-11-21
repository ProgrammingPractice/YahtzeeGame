require_relative 'yahtzee'
require_relative 'dice_roller'

class YahtzeeGame
  attr_reader :categories
  attr_reader :roll
  attr_reader :score

  def initialize(dice_roller = DiceRoller.new)
    @score = 0
    @dice_roller = dice_roller
    @categories = Yahtzee::CATEGORIES.dup
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
    @categories.delete(category)
    @score += Yahtzee.calculate_score(category, roll)
  end
end

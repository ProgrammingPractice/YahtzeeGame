require_relative 'score_calculator'

class Player
  attr_reader :categories
  attr_reader :name
  attr_reader :roll
  attr_reader :score

  def initialize(name, dice_roller)
    @name = name
    @dice_roller = dice_roller
    @score = 0
    @categories = ScoreCalculator::CATEGORIES.dup
  end

  def self.from_h(hash)
    dice_roller = DiceRoller.new
    new(nil, dice_roller).from_h(hash)
  end

  def roll_dice
    @roll = (1..5).map { @dice_roller.roll_one }
  end

  def reroll(positions)
    positions.each do |position|
      @roll[position] = @dice_roller.roll_one
    end
  end

  def select_category(category)
    @categories.delete(category)
    @score += ScoreCalculator.calculate(category, roll)
  end

  def to_h
    {
      :name       => @name,
      :score      => @score,
      :categories => @categories,
      :roll       => @roll,
    }
  end

  def from_h(hash)
    @name       = hash.fetch('name')
    @score      = hash.fetch('score')
    @categories = hash.fetch('categories')
    @roll       = hash.fetch('roll')
    self
  end
end

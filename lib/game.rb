require_relative 'player'

class Game
  attr_reader :players

  def initialize(count, dice_roller = DiceRoller.new)
    @players = (1..count).map { Player.new(dice_roller) }
  end

  def rounds_left?
    !@players.first.categories.empty?
  end

  def winner
    @players.reduce { |a, b| a.score > b.score ? a : b }
  end
end

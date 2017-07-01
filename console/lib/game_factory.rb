require_relative 'dice_roller'
require_relative 'game'
require_relative 'player'

class GameFactory
  def self.create(number_of_players)
    dice_roller = DiceRoller.new
    players = (1..number_of_players).map { |i| Player.new("Player #{i}", dice_roller) }
    Game.new(players)
  end
end

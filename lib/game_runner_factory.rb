require_relative 'dice_roller'
require_relative 'game'
require_relative 'game_runner'
require_relative 'player'

class GameRunnerFactory
  def self.create(number_of_players, ui)
    dice_roller = DiceRoller.new
    players = (1..number_of_players).map { |i| Player.new("Player #{i}", dice_roller) }
    game = Game.new(players)
    ui.set_players(players)
    GameRunner.new(game, ui)
  end
end

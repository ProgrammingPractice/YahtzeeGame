require_relative 'game_factory'
require_relative 'game_runner'

class GameRunnerFactory
  def self.create(number_of_players, ui)
    game = GameFactory.create(number_of_players)
    GameRunner.new(game, ui)
  end
end

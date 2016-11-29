#! /usr/bin/env ruby

require_relative 'lib/game'
require_relative 'lib/game_runner'
require_relative 'lib/player'
require_relative 'lib/dice_roller'

class UI
  def get_number_of_players
    2
  end
end

class GameRunnerFactory
  def self.create(number_of_players, ui)
    dice_roller = DiceRoller.new
    players = (1..number_of_players).map { |i| Player.new("Player #{i}", dice_roller) }
    game = Game.new(players)
    GameRunner.new(game, ui)
  end
end

ui = UI.new
number_of_players = ui.get_number_of_players
game_runner = GameRunnerFactory.create(number_of_players, ui)
puts "DONE"
# game_runner.run

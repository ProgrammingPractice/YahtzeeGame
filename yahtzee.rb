#! /usr/bin/env ruby

require_relative 'lib/game'
require_relative 'lib/game_runner'

class UI
  def get_number_of_players
    2
  end
end

class GameRunnerFactory
  def self.create(number_of_players, ui)
    game = Game.new(number_of_players)
    GameRunner.new(game, ui)
  end
end

ui = UI.new
number_of_players = ui.get_number_of_players
game_runner = GameRunnerFactory.create(number_of_players, ui)
puts "DONE"
# game_runner.run

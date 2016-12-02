#! /usr/bin/env ruby

require_relative 'lib/game_runner_factory'
require_relative 'lib/ui'

ui = UI.new
number_of_players = ui.get_number_of_players
game_runner = GameRunnerFactory.create(number_of_players, ui)
puts "DONE"
# game_runner.run

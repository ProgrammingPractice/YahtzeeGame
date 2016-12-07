#! /usr/bin/env ruby

require_relative 'lib/game_runner_factory'
require_relative 'lib/ui'

ui = UI.new
number_of_players = ui.ask_for_number_of_players
GameRunnerFactory.create(number_of_players, ui).run

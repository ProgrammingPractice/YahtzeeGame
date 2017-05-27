#! /usr/bin/env ruby

require_relative 'lib/game_wrapper_factory'
require_relative 'lib/ui'

# number_of_players = ui.ask_for_number_of_players
number_of_players = 2
game_wrapper = GameWrapperFactory.create(number_of_players)
ui = UI.new(game_wrapper)
ui.run

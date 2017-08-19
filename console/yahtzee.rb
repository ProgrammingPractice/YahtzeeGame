#! /usr/bin/env ruby

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
$LOAD_PATH.unshift(File.expand_path('../core/lib', __dir__))

require 'game_wrapper_factory'
require 'ui'

number_of_players = UI.ask_for_number_of_players
game_wrapper = GameWrapperFactory.create(number_of_players)
ui = UI.new(game_wrapper)
ui.run

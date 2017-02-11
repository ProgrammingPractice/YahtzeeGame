require 'sinatra'

require_relative '../lib/game_factory'
set :dice_roller, DiceRoller.new

require_relative 'lib/game'

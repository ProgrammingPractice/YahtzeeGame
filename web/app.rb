require 'sinatra'
require_relative '../lib/game_factory'

get '/' do
  redirect :new_game
end

get '/new_game' do
  erb :new_game
end

post '/create_game' do
  # TODO: create new game and persist it (probably in cookies)
  redirect :new_round
end

get '/new_round' do
  # TODO: load game from storage

  players_count = 2
  # players_count = params.fetch('players_count').to_i

  game = GameFactory.create(players_count)
  @player = game.players.first

  @roll = [1,2,3,4,5]
  @rolls_count = 1
  @dice_to_hold = ""
  @category_names = []

  erb :new_round
end
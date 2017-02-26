require 'sinatra'

require_relative '../../lib/game_factory'
require_relative 'game_serializer'

set :root, File.dirname(__FILE__) + '/..'
set :dice_roller, DiceRoller.new
enable :sessions

get '/' do
  redirect :new_game
end

get '/new_game' do
  erb :new_game
end

post '/create_game' do
  players_count = params.fetch('players_count').to_i
  game = GameFactory.create(players_count)
  save_game(game)
  session[:rolls_count] = 0
  session[:current_player] = 0
  redirect :new_round
end

get '/new_round' do
  dice_to_hold = params['dice_to_hold']
  if dice_to_hold
    current_player.reroll([0,1,2,3,4] - dice_to_hold.map(&:to_i))
  else
    current_player.roll_dice
  end
  session[:rolls_count] = session[:rolls_count] + 1

  save_current_game

  if session[:rolls_count] == 3 || hold_all_dice(dice_to_hold)
    redirect :category_selection
  else
    erb :new_round
  end
end

get '/category_selection' do
  erb :category_selection
end

post '/select_category' do
  category = params.fetch('category')

  current_player.select_category(category)

  switch_to_next_player

  save_current_game
  redirect :new_round
end

def current_game
  if @_game.nil?
    dice_roller = settings.dice_roller
    @_game = GameSerializer.load(session[:game], dice_roller)
  end
  @_game
end

def current_player
  if @_player.nil?
    @_player = current_game.players[session[:current_player]]
  end
  @_player
end

def save_current_game
  save_game(@_game)
end

def save_game(game)
  session[:game] = GameSerializer.dump(game)
end

def switch_to_next_player
  session[:rolls_count] = 0
  session[:current_player] = (session[:current_player] + 1) % current_game.players.size
end

def hold_all_dice(dice_to_hold)
  dice_to_hold && dice_to_hold.size == 5
end

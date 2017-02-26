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
  @game = load_game
  @player = @game.players[session[:current_player]]

  dice_to_hold = params['dice_to_hold']
  if dice_to_hold
    @player.reroll([0,1,2,3,4] - dice_to_hold.map(&:to_i))
  else
    @player.roll_dice
  end
  session[:rolls_count] = session[:rolls_count] + 1

  save_game(@game)

  if session[:rolls_count] == 3
    redirect :category_selection
  else
    erb :new_round
  end
end

get '/category_selection' do
  @game = load_game
  @player = @game.players[session[:current_player]]

  erb :category_selection
end

post '/select_category' do
  category = params.fetch('category')

  @game = load_game
  @player = @game.players.first

  @player.select_category(category)

  switch_to_next_player

  save_game(@game)
  redirect :new_round
end

def load_game
  dice_roller = settings.dice_roller
  GameSerializer.load(session[:game], dice_roller)
end

def save_game(game)
  session[:game] = GameSerializer.dump(game)
end

def switch_to_next_player
  session[:rolls_count] = 0
  session[:current_player] += 1
end

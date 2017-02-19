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
  session[:rolls_count] = 1
  session[:current_player] = 0
  redirect :new_round
end

get '/new_round' do
  @rolls_count = session[:rolls_count]

  @game = load_game
  @player = @game.players[session[:current_player]]

  dice_to_hold = params['dice_to_hold']
  if dice_to_hold
    @player.reroll([0,1,2,3,4] - dice_to_hold.map(&:to_i))
  else
    @player.roll_dice
  end

  save_game(@game)
  session[:rolls_count] = @rolls_count + 1
  erb :new_round
end

post '/select_category' do
  category = params.fetch('category')

  @game = load_game
  @player = @game.players.first

  @player.select_category(category)

  session[:rolls_count] = 1
  session[:current_player] += 1

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

require_relative '../../lib/game_factory'
require_relative 'game_serializer'

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
  redirect :new_round
end

get '/new_round' do
  @rolls_count = session[:rolls_count]

  @game = load_game
  @player = @game.players.first

  @player.roll_dice

  save_game(@game)
  session[:rolls_count] = @rolls_count + 1
  erb :new_round
end

post '/select_category' do
  category = params.fetch('category')

  @game = load_game
  @player = @game.players.first

  @player.select_category(category)

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

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
  session[:game] = GameSerializer.dump(game)
  redirect :new_round
end

get '/new_round' do
  game = GameSerializer.load(session.fetch(:game))
  @player = game.players.first

  @roll = [1,2,3,4,5]
  @rolls_count = 1
  @dice_to_hold = "DICE TO HOLD"
  @category_names = @player.categories

  erb :new_round
end

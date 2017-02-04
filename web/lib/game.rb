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
  session[:rolls_count] = 1
  redirect :new_round
end

get '/new_round' do
  @rolls_count = session[:rolls_count]

  game = GameSerializer.load(session[:game])
  @players = game.players
  @player  = @players.first

  @player.roll_dice

  session[:rolls_count] = @rolls_count + 1
  erb :new_round
end

post '/select_category' do
  category = params.fetch('category')

  game = GameSerializer.load(session[:game])
  @players = game.players
  @player  = @players.first

  # FIXME: rolling the dice is needed because we don't store the roll in the
  # serialized version of the game
  @player.roll_dice
  @player.select_category(category)

  session[:game] = GameSerializer.dump(game)
  redirect :new_round
end

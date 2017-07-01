require 'sinatra/base'

require_relative '../../console/lib/game_factory'
require_relative 'game_serializer'

class YahtzeeWeb < Sinatra::Base
  set :root, File.expand_path(File.join(File.dirname(__FILE__), '..'))
  enable :sessions

  def initialize(dice_roller = DiceRoller.new)
    super
    @dice_roller = dice_roller
  end

  get '/' do
    redirect :new_game
  end

  get '/new_game' do
    erb :new_game
  end

  post '/create_game' do
    players_count = params.fetch('players_count').to_i
    game = GameFactory.create(players_count)
    create_new_game(game)
    redirect :new_round
  end

  get '/new_round' do
    dice_to_hold = params['dice_to_hold']
    if dice_to_hold
      current_player.reroll([0,1,2,3,4] - dice_to_hold.map(&:to_i))
    else
      current_player.roll_dice
    end
    increase_rolls_count

    save_game

    if rolls_count == 3 || hold_all_dice(dice_to_hold)
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

    save_game
    redirect :new_round
  end

  get '/favicon.ico' do
  end

  private

  def create_new_game(game)
    session[:game]           = GameSerializer.dump(game)
    session[:current_player] = 0
    reset_rolls_count
  end

  def save_game
    session[:game] = GameSerializer.dump(@_game)
  end

  def current_game
    @_game ||= GameSerializer.load(session[:game], @dice_roller)
  end

  def current_player
    @_player ||= current_game.players[session[:current_player]]
  end

  def switch_to_next_player
    reset_rolls_count
    session[:current_player] = (session[:current_player] + 1) % current_game.players.size
  end

  def rolls_count
    session[:rolls_count]
  end

  def reset_rolls_count
    session[:rolls_count] = 0
  end

  def increase_rolls_count
    session[:rolls_count] = session[:rolls_count] + 1
  end

  def hold_all_dice(dice_to_hold)
    dice_to_hold && dice_to_hold.size == 5
  end

  run! if app_file == $0
end

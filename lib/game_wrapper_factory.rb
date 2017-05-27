require_relative 'game_factory'
require_relative 'game_wrapper'

class GameWrapperFactory
  def self.create(number_of_players)
    game = GameFactory.create(number_of_players)
    GameWrapper.new(game)
  end
end

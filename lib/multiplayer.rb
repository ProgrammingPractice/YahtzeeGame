require_relative 'game'

class Multiplayer
  attr_reader :players

  def initialize(count)
    @players = (1..count).map { Game.new }
  end
end

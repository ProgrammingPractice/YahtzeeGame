require_relative 'player'

class Multiplayer
  attr_reader :players

  def initialize(count)
    @players = (1..count).map { Player.new }
  end
end

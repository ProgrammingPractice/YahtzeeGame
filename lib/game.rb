class Game
  attr_reader :players

  def initialize(players)
    @players = players
  end

  def rounds_left?
    !@players.first.categories.empty?
  end

  def winner
    @players.reduce { |a, b| a.score > b.score ? a : b }
  end
end

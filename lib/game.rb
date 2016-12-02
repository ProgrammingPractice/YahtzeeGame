class Game
  attr_reader :players

  def initialize(players)
    @players = players
  end

  def rounds_left?
    !@players.first.categories.empty?
  end

  def winners
    maximum_score = @players.map(&:score).max
    @players.select {|p| p.score == maximum_score}
  end
end

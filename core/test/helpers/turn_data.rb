class TurnData
  attr_reader :player_name
  attr_reader :roll0
  attr_reader :hold0
  attr_reader :roll1
  attr_reader :hold1
  attr_reader :roll2
  attr_reader :category
  attr_reader :score

  def initialize(
    player_name:,
    roll0:,
    hold0:,
    roll1:,
    hold1:,
    roll2:,
    category:,
    score:
  )
    @player_name = player_name
    @roll0       = roll0
    @hold0       = hold0
    @roll1       = roll1
    @hold1       = hold1
    @roll2       = roll2
    @category    = category
    @score       = score
  end

  def to_s
    {
      player_name: @player_name,
      roll0:       @roll0,
      hold0:       @hold0,
      roll1:       @roll1,
      hold1:       @hold1,
      roll2:       @roll2,
      category:    @category,
      score:       @score
    }.to_s
  end

end

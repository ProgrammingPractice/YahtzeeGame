class TestData
  attr_reader :current_round
  attr_reader :player_names

  def initialize(rounds)
    @player_names = rounds.keys

    @rounds_iterators = rounds.each_with_object({}) do |(player, player_rounds), hash|
      hash[player] = player_rounds.each
    end
  end

  def advance_to_next_round(player)
    @current_round = @rounds_iterators[player.name].next
  end

  def extract_category
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    category
  end

  def extract_dice
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    roll0 + roll1 + roll2
  end

  def extract_hold_positions
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
    hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
    [hold_positions0, hold_positions1]
  end

  def extract_score
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    score
  end
end

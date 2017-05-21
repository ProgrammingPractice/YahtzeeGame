class TestData
  attr_reader :current_round
  attr_reader :player_names

  def initialize(rounds)
    @player_names = rounds.keys

    @rounds_iterators = rounds.each_with_object({}) do |(player, player_rounds), hash|
      hash[player] = player_rounds.each
    end

    advance_to_next_round
  end

  def advance_to_next_round
    advance_current_player
    @current_round = @rounds_iterators[@current_player].next
    @hold_positions = extract_hold_positions
  end

  private def advance_current_player
    if @current_player.nil?
      @player_index = 0
    else
      @player_index = (@player_index + 1) % @player_names.size
    end

    @current_player = @player_names[@player_index]
  end

  def extract_category
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    category
  end

  def extract_dice
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    roll0 + roll1 + roll2
  end

  def next_hold_positions
    @hold_positions.shift or raise "We were asked for hold positions, but did not expect it."
  end

  private def extract_hold_positions
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
    hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
    [hold_positions0, hold_positions1]
  end

  def extract_score_and_advance_round
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    advance_to_next_round
    score
  end
end

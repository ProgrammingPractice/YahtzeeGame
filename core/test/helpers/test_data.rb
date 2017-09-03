class TestData
  attr_reader :current_player
  attr_reader :current_round
  attr_reader :player_names

  def initialize(rounds, dice_roller)
    @player_names = rounds.keys
    @dice_roller = dice_roller

    @rounds_iterators = rounds.each_with_object({}) do |(player, player_rounds), hash|
      hash[player] = player_rounds.each
    end

    advance_to_next_player
  end

  def advance_to_next_player
    advance_current_player
    @current_round = @rounds_iterators[@current_player].next
    @hold_positions = extract_hold_positions

    @dice_roller.move_to_next_round(self)
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
    @hold_positions.shift or unexpected_request_for_hold_positions
  end

  private def unexpected_request_for_hold_positions
    raise <<~STRING
      TestData was asked for hold positions, but did not expect it.
        Player: #{current_player}
        Raw round: #{current_round.inspect}
    STRING
  end

  private def extract_hold_positions
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
    hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
    [hold_positions0, hold_positions1]
  end

  def extract_score
    (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
    score
  end

  def players_count
    player_names.size
  end
end

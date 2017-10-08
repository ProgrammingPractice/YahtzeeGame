class TestData
  attr_reader :player_turn_data

  def initialize(player_turns, dice_roller)
    @players = player_turns.keys
    @dice_roller  = dice_roller

    @turns_iterators = player_turns.each_with_object({}) do |(player, player_rounds), hash|
      hash[player] = player_rounds.each
    end

    advance_to_next_player
  end

  def current_player_name
    @current_player
  end

  def player_names
    @players
  end

  def turns_count
    30
  end

  def advance_to_next_player
    advance_current_player
    @player_turn_data = @turns_iterators[@current_player].next
    @hold_positions = extract_hold_positions

    @dice_roller.move_to_next_round(self)
  end

  private def advance_current_player
    if @current_player.nil?
      @player_index = 0
    else
      @player_index = (@player_index + 1) % @players.size
    end

    @current_player = @players[@player_index]
  end

  def extract_category
    (roll0, hold0, roll1, hold1, roll2, category, score) = @player_turn_data
    category
  end

  def extract_dice
    (roll0, hold0, roll1, hold1, roll2, category, score) = @player_turn_data
    roll0 + roll1 + roll2
  end

  def next_hold_positions
    @hold_positions.shift or unexpected_request_for_hold_positions
  end

  private def unexpected_request_for_hold_positions
    raise <<~STRING
      TestData was asked for hold positions, but did not expect it.
        Player: #{current_player}
        Raw round: #{player_turn_data.inspect}
    STRING
  end

  private def extract_hold_positions
    (roll0, hold0, roll1, hold1, roll2, category, score) = @player_turn_data
    hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
    hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
    [hold_positions0, hold_positions1]
  end

  def extract_score
    (roll0, hold0, roll1, hold1, roll2, category, score) = @player_turn_data
    score
  end

  def players_count
    @players.size
  end
end

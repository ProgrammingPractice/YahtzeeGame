class FakeDiceRoller
  def initialize(values = [])
    @values        = values
    @rolled_values = []
  end

  def roll_one
    if @values.empty?
      value = 10
    else
      value = @values.shift
    end
    @rolled_values << value
    value
  end

  def setup(rounds)
    @players = rounds.keys
    @current_player_index = 0
  end

  def current_player
    @players[@current_player_index]
  end

  def ensure_exact_use_of_dice
    if @current_round_values != @rolled_values
      message = <<~STRING
        Dice mismatch.
          In the current round the number of dice provided and dice used do not match:
          Player: #{@player_name}
          Raw round: #{@raw_round.inspect}
          Dice provided by test: #{@current_round_values}
          Dice used by game:     #{@rolled_values}
      STRING

      raise message
    end

    advance_to_next_player
  end

  def advance_to_next_player
    @current_player_index = (@current_player_index + 1) % @players.size
  end

  def move_to_next_round(raw_round)
    @player_name   = current_player
    @raw_round     = raw_round
    @rolled_values = []

    dice = raw_round[0] + raw_round[2] + raw_round[4]
    add_values_for_round(dice)
  end

  private

  def add_values_for_round(values)
    raise 'Values should be empty when round begins' if @values.any?
    @current_round_values = values.dup
    @values = values.dup
  end
end

class FakeDiceRoller
  def initialize(values = [])
    @values        = values
    @rolled_values = []
  end

  def roll_one
    if @values.empty?
      value = 'OutOfValues'
    else
      value = @values.shift
    end
    @rolled_values << value
    value
  end

  def add_values_for_round(values)
    raise 'Values should be empty when round begins' if @values.any?
    @current_round_values = values.dup
    @values = values.dup
  end

  def empty?
    @values.empty?
  end

  def ensure_exact_use_of_dice
    if @current_round_values != @rolled_values
      message = <<~STRING
        Dice mismatch.
          In the current round the number of dice provided and dice used do not match:
          Dice provided by test: #{@current_round_values}
          Dice used by game:     #{@rolled_values}
      STRING

      raise message
    end

    move_to_next_round
  end

  def move_to_next_round
    @rolled_values = []
  end
end

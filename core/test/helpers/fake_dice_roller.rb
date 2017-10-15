class FakeDiceRoller
  def initialize(values = [])
    @values        = values
    @rolled_values = []
  end

  def roll_one
    if @values.empty?
      @rolled_values << 'extra_value'
      ensure_exact_use_of_dice
    end

    value = @values.shift
    @rolled_values << value
    value
  end

  def ensure_exact_use_of_dice
    # This method is useful when a test fails.
    # It checks both cases:
    #   - More dice used than available.
    #   - Fewer dice used than available.

    if @current_group_values != @rolled_values
      message = <<~STRING
        Dice mismatch.
          In the current group the number of dice provided and dice used do not match:
          Player: #{@test_data.current_player}
          Raw turn data: #{@test_data.player_turn_data.inspect}
          Dice provided by test: #{@current_group_values}
          Dice used by game:     #{@rolled_values}
      STRING

      raise message
    end
  end

  def move_to_next_group(test_data)
    @test_data = test_data

    @rolled_values = []

    add_values_for_group(test_data.extract_dice)
  end

  def add_values_for_group(values)
    raise 'Values should be empty when group begins' if @values.any?
    @current_group_values = values.dup
    @values = values.dup
  end
end

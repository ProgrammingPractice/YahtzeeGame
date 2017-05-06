class FakeDiceRoller
  attr_reader :rolled_values, :current_round_values

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

  def move_to_next_round
    @rolled_values = []
  end
end

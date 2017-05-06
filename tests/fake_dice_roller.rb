class FakeDiceRoller
  class OutOfValuesError < RuntimeError; end

  attr_reader :rolled_values

  def initialize(values = [])
    @values        = values
    @rolled_values = []
  end

  def roll_one
    if @values.empty?
      raise OutOfValuesError
    end
    value = @values.shift
    @rolled_values << value
    value
  end

  def add_values(values)
    @values.concat(values)
  end

  def empty?
    @values.empty?
  end

  def move_to_next_round
    @rolled_values = []
  end
end

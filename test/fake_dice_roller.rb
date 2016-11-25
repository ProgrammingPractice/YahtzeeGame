class FakeDiceRoller
  def initialize(values)
    @values = values
  end

  def roll_one
    @values.shift
  end

  def add_values(values)
    @values.concat(values)
  end
end

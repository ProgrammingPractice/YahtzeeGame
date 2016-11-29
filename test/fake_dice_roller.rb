class FakeDiceRoller
  def initialize(values)
    @values = values
  end

  def roll_one
    if @values.empty?
      raise "FakeDiceRoller has no more values but was asked to roll!"
    end
    @values.shift
  end

  def add_values(values)
    @values.concat(values)
  end
end

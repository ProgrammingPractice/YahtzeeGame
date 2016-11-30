class FakeDiceRoller
  class OutOfValuesError < RuntimeError; end

  def initialize(values)
    @values = values
  end

  def roll_one
    if @values.empty?
      raise OutOfValuesError
    end
    @values.shift
  end

  def add_values(values)
    @values.concat(values)
  end
end

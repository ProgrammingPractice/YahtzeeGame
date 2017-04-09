class GameWrapper
  def initialize(game)
    @game = game
  end

  def players
    @game.players
  end

  def rounds_left?
    @game.rounds_left?
  end

  def winners
    @game.winners
  end

  def start_round(player)
    @player = player
    @current_step = 0
    @hold_positions = []
  end

  def one_step_of_round
    actions = {
      ask_for_hold_positions: ->(input) { @hold_positions = input; @player.reroll(positions_to_reroll(input)) },
      ask_for_category:       ->(input) { @player.select_category(input) },
    }

    steps = [
      :ask_for_hold_positions,
      :ask_for_hold_positions,
      :ask_for_category,
    ]

    if @current_step == 0
      @player.roll_dice
      yield(steps[0], actions[steps[0]])
      @current_step = 1
    elsif @current_step == 1
      if @hold_positions.size < 5
        yield(steps[1], actions[steps[1]])
      end
      @current_step = 2
    else
      yield(steps[2], actions[steps[2]])
      @current_step = -1
    end
  end

  def round_finished?
    @current_step == -1
    # true
  end

  private

  def positions_to_reroll(hold)
    [0, 1, 2, 3, 4] - hold
  end
end

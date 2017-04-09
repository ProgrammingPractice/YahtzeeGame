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
    @steps = [
      [
        :ask_for_hold_positions,
        ->(hold_positions) do
          # FIXME: we should roll before asking the user for hold positions.
          @player.roll_dice
          @player.reroll(positions_to_reroll(hold_positions))
        end
      ],
      [
        :ask_for_hold_positions,
        ->(hold_positions) do
          @player.reroll(positions_to_reroll(hold_positions))
        end
      ],
      [
        :ask_for_category,
        ->(category) do
          @player.select_category(category)
        end
      ],
    ]

    @player = player
    @current_step = 0
  end

  def next_step_of_round
    @steps[@current_step][0]
  end

  def advance(input_from_user)
    callback = @steps[@current_step][1]
    callback.call(input_from_user)
    advance_current_step(input_from_user)
  end

  def advance_current_step(input_from_user)
    if input_from_user.is_a?(Array) && input_from_user.size == 5
      @current_step += 2
    else
      @current_step += 1
    end
  end

  def round_finished?
    @current_step == 3
  end

  private

  def positions_to_reroll(hold)
    [0, 1, 2, 3, 4] - hold
  end
end

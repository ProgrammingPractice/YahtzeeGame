class GameWrapper
  def initialize(game)
    @game = game
  end

  def current_player_score
    @current_player.score
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

  def advance_to_next_player
    if @current_player.nil?
      @player_index = 0
    else
      @player_index = (@player_index + 1) % players.size
    end

    @current_player = players[@player_index]
    @current_step = 0
  end

  def next_step_of_round
    steps[@current_step][0]
  end

  def advance(input_from_user)
    callback = steps[@current_step][1]
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

  def steps
    [
      [
        :ask_for_hold_positions,
        ->(hold_positions) do
          # FIXME: we should roll before asking the user for hold positions.
          @current_player.roll_dice
          @current_player.reroll(positions_to_reroll(hold_positions))
        end
      ],
      [
        :ask_for_hold_positions,
        ->(hold_positions) do
          @current_player.reroll(positions_to_reroll(hold_positions))
        end
      ],
      [
        :ask_for_category,
        ->(category) do
          @current_player.select_category(category)
        end
      ],
    ]
  end
end

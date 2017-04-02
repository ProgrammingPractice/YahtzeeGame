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

  def each_step(player, &block)
    hold_positions = []
    actions = {
      ask_for_nothing:        ->(_input) { player.roll_dice },
      ask_for_hold_positions: ->(input) { hold_positions = input; player.reroll(positions_to_reroll(input)) },
      ask_for_category:       ->(input) { player.select_category(input) },
    }

    steps = [
      [
        :ask_for_nothing,
        actions[:ask_for_nothing]
      ],
      [
        :ask_for_hold_positions,
        actions[:ask_for_hold_positions]
      ],
      [
        :ask_for_hold_positions,
        actions[:ask_for_hold_positions]
      ],
      [
        :ask_for_category,
        actions[:ask_for_category]
      ]
    ]

    yield(steps[0])
    yield(steps[1])
    if hold_positions.size < 5
      yield(steps[2])
    end
    yield(steps[3])
  end

  private

  def positions_to_reroll(hold)
    [0, 1, 2, 3, 4] - hold
  end
end

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

  def steps(player)
    actions = {
      ask_for_nothing:        ->(_input) { player.roll_dice },
      ask_for_hold_positions: ->(input) { player.reroll(positions_to_reroll(input)) },
      ask_for_category:       ->(input) { player.select_category(input) },
    }

    [
      [
        :ask_for_nothing,
        false,
        actions[:ask_for_nothing]
      ],
      [
        :ask_for_hold_positions,
        false,
        actions[:ask_for_hold_positions]
      ],
      [
        :ask_for_hold_positions,
        true,
        actions[:ask_for_hold_positions]
      ],
      [
        :ask_for_category,
        false,
        actions[:ask_for_category]
      ]
    ]
  end

  private

  def positions_to_reroll(hold)
    [0, 1, 2, 3, 4] - hold
  end
end

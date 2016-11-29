class GameRunner
  def initialize(game, ui)
    @game = game
    @ui   = ui
  end

  def run
    while @game.rounds_left?
      @game.players.each do |player|
        play_round(player)
      end
    end

    @ui.display_winner(@game.winner)
  end

  def play_round(player)
    player.roll_dice
    @ui.display_roll(player.roll)

    hold = @ui.ask_for_hold_positions
    player.reroll([0,1,2,3,4] - hold)
    @ui.display_roll(player.roll)

    # hold = @ui.ask_for_hold_positions
    # player.reroll(!hold)
    # @ui.display_roll(player.roll)

    category = @ui.ask_for_category
    player.select_category(category)
  end
end

class GameRunner
  def initialize(ui)
    @ui = ui
  end

  def run
    count = @ui.get_number_of_players
    game = Game.new(count)
    while game.rounds_left?
      game.players.each do |player|
        play_round(player)
      end
    end

    @ui.display_winner(game.winner)
  end

  def play_round(player)
    player.roll_dice
    category = @ui.ask_for_category
    player.select_category(category)
  end
end

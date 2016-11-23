class GameRunner
  def initialize(ui)
    @ui = ui
  end

  def run
    count = @ui.get_number_of_players
    game = Game.new(count)
    while game.rounds_left?
      # ...
    end

    @ui.display_winner(0)
    # TODO:
    # @ui.display_winner(game.winner)
  end
end

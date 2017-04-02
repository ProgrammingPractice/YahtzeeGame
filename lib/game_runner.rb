require_relative 'game_wrapper'

class GameRunner
  def initialize(game, ui)
    @game_wrapper = GameWrapper.new(game)
    @ui           = ui
  end

  def run
    @ui.start_game_with_players(@game_wrapper.players)

    while @game_wrapper.rounds_left?
      @game_wrapper.players.each do |player|
        play_round(player)
      end
    end

    @ui.display_winners(@game_wrapper.winners)
  end

  def play_round(player)
    @ui.start_of_player_turn(player)

    player.roll_dice
    @ui.display_roll(player.roll)

    hold = @ui.ask_for_hold_positions
    player.reroll(positions_to_reroll(hold))
    @ui.display_roll(player.roll)

    if hold.size < 5
      hold = @ui.ask_for_hold_positions
      player.reroll(positions_to_reroll(hold))
      @ui.display_roll(player.roll)
    end

    category = @ui.ask_for_category
    player.select_category(category)

    @ui.end_of_player_turn(player)
  end

  private

  def positions_to_reroll(hold)
    [0,1,2,3,4] - hold
  end
end

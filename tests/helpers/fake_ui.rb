class FakeUI
  attr_reader :output

  def initialize(test, test_data, dice_roller)
    @test        = test
    @test_data   = test_data
    @dice_roller = dice_roller
    @output      = []
  end

  def run(game_wrapper)
    loop do
      ui_action = game_wrapper.next_step
      # values for ui_action: ask_for_hold_positions, ask_for_category
      input_from_user = send(ui_action)
      game_wrapper.advance(input_from_user)

      if game_wrapper.round_finished?
        end_of_player_turn_assertions(game_wrapper)
      end

      break unless game_wrapper.rounds_left?
    end

    display_winners(game_wrapper.winners)
  end

  def end_of_player_turn_assertions(game_wrapper)
    @dice_roller.ensure_exact_use_of_dice

    actual_score   = game_wrapper.score(@test_data.current_player)
    expected_score = @test_data.extract_score_and_advance_round

    @test.assert_equal expected_score, actual_score
  end

  def display_winners(players)
    @output << "#{players.map(&:name).join(' & ')} won with #{players.first.score} points!"
  end

  def ask_for_hold_positions
    @test_data.next_hold_positions
  end

  def ask_for_category
    @test_data.extract_category
  end
end

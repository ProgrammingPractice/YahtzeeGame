class FakeUI
  attr_reader :output

  def initialize(test, rounds, dice_roller)
    @test        = test
    @dice_roller = dice_roller
    @output      = []

    @dice_roller.setup(rounds)

    @test_data = TestData.new(rounds)
  end

  def run(game_wrapper)
    loop do
      game_wrapper.players.each do |player|
        player_round(player, game_wrapper)
      end

      break unless game_wrapper.rounds_left?
    end

    display_winners(game_wrapper.winners)
  end

  def player_round(player, game_wrapper)
    start_of_player_turn(player)
    game_wrapper.start_round(player)
    player_ui_interaction(game_wrapper)
    end_of_player_turn(player)
  end

  def player_ui_interaction(game_wrapper)
    loop do
      ui_action = game_wrapper.next_step_of_round
      input_from_user = send(ui_action)
      game_wrapper.advance(input_from_user)

      break if game_wrapper.round_finished?
    end
  end

  def start_of_player_turn(player)
    @test_data.advance_to_next_round(player)
    @dice_roller.move_to_next_round(@test_data)
    @hold_positions = @test_data.extract_hold_positions
  end

  def end_of_player_turn(player)
    @dice_roller.ensure_exact_use_of_dice

    expected_score = @test_data.extract_score
    @test.assert_equal expected_score, player.score
  end

  def display_winners(players)
    @output << "#{players.map(&:name).join(' & ')} won with #{players.first.score} points!"
  end

  def ask_for_hold_positions
    @hold_positions.shift or raise "We were asked for hold positions, but did not expect it."
  end

  def ask_for_category
    @test_data.extract_category
  end
end
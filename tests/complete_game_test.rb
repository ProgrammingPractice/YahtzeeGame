require_relative 'test_helper'
require 'json'

class CompleteGameTest < Minitest::Test
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

  class TestData
    attr_reader :current_round

    def initialize(rounds)
      @rounds_iterators = rounds.each_with_object({}) do |(player, player_rounds), hash|
        hash[player] = player_rounds.each
      end
    end

    def advance_to_next_round(player)
      @current_round = @rounds_iterators[player.name].next
    end

    def extract_category
      (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
      category
    end

    def extract_dice
      (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
      roll0 + roll1 + roll2
    end

    def extract_hold_positions
      (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
      hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
      hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
      [hold_positions0, hold_positions1]
    end

    def extract_score
      (roll0, hold0, roll1, hold1, roll2, category, score) = @current_round
      score
    end
  end

  def test_complete_game
    json = JSON.parse(File.read('tests/fixtures/complete_game.json'))
    rounds_p0 = json['rounds_p0']
    rounds_p1 = json['rounds_p1']

    dice_roller = FakeDiceRoller.new([])
    player0     = Player.new('Player 0', dice_roller)
    player1     = Player.new('Player 1', dice_roller)
    game        = Game.new([player0, player1])

    rounds = {
      player0.name => rounds_p0,
      player1.name => rounds_p1,
    }

    ui           = FakeUI.new(self, rounds, dice_roller)
    game_wrapper = GameWrapper.new(game)

    ui.run(game_wrapper)
    assert_equal "Player 1 won with 75 points!", ui.output.last
  end
end

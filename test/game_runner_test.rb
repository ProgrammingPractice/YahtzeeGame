require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    attr_reader :output

    def initialize(test, rounds)
      @test   = test
      @rounds = rounds
      @output = []
    end

    def next_players_turn(player)
      @current_round = @rounds.shift
    end

    def display_roll(roll)
      # nothing
    end

    def display_score(score)
      expected_score = extract_score(*@current_round)
      @test.assert_equal expected_score, score
    end

    def display_winner(player)
      @output << "#{player.name} won with #{player.score} points!"
    end

    def ask_for_hold_positions
      extract_hold_positions(*@current_round)
    end

    def ask_for_category
      extract_category(*@current_round)
    end

    private

    def extract_hold_positions(roll0, hold0, roll1, category, score)
      [0,1,2,3,4].select { |i| hold0[i] == 'x' }
    end

    def extract_category(roll0, hold0, roll1, category, score)
      category
    end

    def extract_score(roll0, hold0, roll1, category, score)
      score
    end
  end

  def test_complete_game
    # TODO:
    #   - holding dice
    #   - multiple players

    data = [
      [[1,2,6,4,5], 'xx_xx', [3], 'chance',          15],
      [[1,1,1,1,1], 'xxxxx', [],  'yahtzee',         65],
      [[1,1,1,1,1], 'xxxxx', [],  'ones',            70],
      [[1,1,1,1,1], 'xxxxx', [],  'twos',            70],
      [[1,1,1,1,1], 'xxxxx', [],  'threes',          70],
      [[1,1,1,1,1], 'xxxxx', [],  'fours',           70],
      [[1,1,1,1,1], 'xxxxx', [],  'fives',           70],
      [[1,1,1,1,1], 'xxxxx', [],  'sixes',           70],
      [[1,1,1,1,1], 'xxxxx', [],  'pair',            70],
      [[1,1,1,1,1], 'xxxxx', [],  'two_pairs',       70],
      [[1,1,1,1,1], 'xxxxx', [],  'three_of_a_kind', 70],
      [[1,1,1,1,1], 'xxxxx', [],  'four_of_a_kind',  70],
      [[1,1,1,1,1], 'xxxxx', [],  'small_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],  'large_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],  'full_house',      70],
    ]

    dice_roller = prepare_fake_dice_roller(data)
    player      = Player.new('Player 1', dice_roller)
    game        = Game.new([player])
    ui          = prepare_ui(data)
    runner      = GameRunner.new(game, ui)

    runner.run
    assert_equal "Player 1 won with 70 points!", ui.output.last
  end

  private

  def prepare_ui(data)
    FakeUI.new(self, data)
  end

  def prepare_fake_dice_roller(data)
    rolls = data.map { |(r0, h0, r1, category, score)| r0 + r1 }.flatten
    FakeDiceRoller.new(rolls)
  end
end
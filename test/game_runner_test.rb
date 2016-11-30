require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    attr_reader :current_round
    attr_reader :output

    def initialize(test, rounds, dice_roller)
      @test        = test
      @dice_roller = dice_roller

      @output = []
      @rounds_iterator = rounds.each
    end

    def start_of_player_turn(player)
      @current_round = @rounds_iterator.next
      @dice_roller.add_values(extract_rolls(*@current_round))
      @hold_positions = extract_hold_positions(*@current_round)
    end

    def end_of_player_turn(player)
      unless @dice_roller.empty?
        raise "Too many dice values were provided in the round: #{@current_round.inspect}"
      end

      expected_score = extract_score(*@current_round)
      @test.assert_equal expected_score, player.score
    end

    def display_roll(roll)
      # nothing
    end

    def display_winner(player)
      @output << "#{player.name} won with #{player.score} points!"
    end

    def ask_for_hold_positions
      @hold_positions.shift
    end

    def ask_for_category
      extract_category(*@current_round)
    end

    private

    def extract_hold_positions(roll0, hold0, roll1, hold1, roll2, category, score)
      [
        [0,1,2,3,4].select { |i| hold0[i] == 'x' },
        [0,1,2,3,4].select { |i| hold1[i] == 'x' }
      ]
    end

    def extract_category(roll0, hold0, roll1, hold1, roll2, category, score)
      category
    end

    def extract_score(roll0, hold0, roll1, hold1, roll2, category, score)
      score
    end

    def extract_rolls(roll0, hold0, roll1, hold1, roll2, category, score)
      roll0 + roll1 + roll2
    end
  end

  def test_complete_game
    # TODO:
    #   - holding dice
    #   - multiple players

    rounds = [
      [[1,2,6,4,5], 'xx_xx', [5],   'xx_xx', [3], 'chance',          15],
      [[6,6,1,1,1], '__xxx', [5,1], '_xxxx', [1], 'yahtzee',         65],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'ones',            70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'twos',            70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'threes',          70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'fours',           70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'fives',           70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'sixes',           70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'pair',            70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'two_pairs',       70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'three_of_a_kind', 70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'four_of_a_kind',  70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'small_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'large_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],    'xxxxx', [],  'full_house',      70],
    ]

    dice_roller = FakeDiceRoller.new([])
    player      = Player.new('Player 1', dice_roller)
    game        = Game.new([player])
    ui          = FakeUI.new(self, rounds, dice_roller)
    runner      = GameRunner.new(game, ui)

    begin
      runner.run
    rescue FakeDiceRoller::OutOfValuesError
      raise "Not enough dice values were provided in the round: #{ui.current_round.inspect}"
    end
    assert_equal "Player 1 won with 70 points!", ui.output.last
  end
end

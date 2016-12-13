require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    attr_reader :current_round
    attr_reader :output

    def initialize(test, rounds, dice_roller)
      @test        = test
      @dice_roller = dice_roller
      @output      = []

      @rounds_iterators = rounds.each_with_object({}) do |(player, player_rounds), hash|
        hash[player] = player_rounds.each
      end
    end

    def start_game_with_players(players)
      # nothing
    end

    def start_of_player_turn(player)
      @current_round = @rounds_iterators[player.name].next
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

    def display_winners(players)
      @output << "#{players.map(&:name).join(' & ')} won with #{players.first.score} points!"
    end

    def ask_for_hold_positions
      @hold_positions.shift or raise "We were asked for hold positions, but did not expect it."
    end

    def ask_for_category
      extract_category(*@current_round)
    end

    private

    def extract_hold_positions(roll0, hold0, roll1, hold1, roll2, category, score)
      hold_positions0 = [0,1,2,3,4].select { |i| hold0[i] == 'x' }
      hold_positions1 = [0,1,2,3,4].select { |i| hold1[i] == 'x' } unless hold1.empty?
      [hold_positions0, hold_positions1]
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
    rounds_p0 = [
      [[1,2,6,4,5], 'xx_xx', [5],   'xx_xx', [3], 'chance',          15],
      [[6,6,1,1,1], '__xxx', [5,1], '_xxxx', [1], 'yahtzee',         65],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'ones',            70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'twos',            70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'threes',          70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'fours',           70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'fives',           70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'sixes',           70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'pair',            70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'two_pairs',       70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'three_of_a_kind', 70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'four_of_a_kind',  70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'small_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'large_straight',  70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'full_house',      70],
    ]
    rounds_p1 = [
      [[2,3,4,5,6], 'xxxxx', [],    '',      [], 'chance',           20],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [], 'yahtzee',          70],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'ones',            75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'twos',            75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'threes',          75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'fours',           75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'fives',           75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'sixes',           75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'pair',            75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'two_pairs',       75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'three_of_a_kind', 75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'four_of_a_kind',  75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'small_straight',  75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'large_straight',  75],
      [[1,1,1,1,1], 'xxxxx', [],    '',      [],  'full_house',      75],
    ]

    dice_roller = FakeDiceRoller.new([])
    player0     = Player.new('Player 0', dice_roller)
    player1     = Player.new('Player 1', dice_roller)
    game        = Game.new([player0, player1])

    rounds = {
      player0.name => rounds_p0,
      player1.name => rounds_p1,
    }

    ui     = FakeUI.new(self, rounds, dice_roller)
    runner = GameRunner.new(game, ui)

    begin
      runner.run
    rescue FakeDiceRoller::OutOfValuesError
      raise "Not enough dice values were provided in the round: #{ui.current_round.inspect}"
    end
    assert_equal "Player 1 won with 75 points!", ui.output.last
  end
end

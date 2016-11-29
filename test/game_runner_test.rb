require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    def initialize(test, categories, hold_positions, scores)
      @test = test
      @categories = categories
      @hold_positions = hold_positions
      @scores = scores
      @output = []
    end

    def display_winner(player)
      @output << "#{player.name} won with #{player.score} points!"
    end

    def display_roll(roll)
    end

    def display_score(score)
      @test.assert_equal @scores.shift, score
    end

    def last_output
      @output.last
    end

    def ask_for_category
      @categories.shift
    end

    def ask_for_hold_positions
      @hold_positions.shift
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
    assert_equal "Player 1 won with 70 points!", ui.last_output
  end

  private

  def prepare_ui(data)
    categories = data.map { |(r0, h0, r1, category, score)| category }
    hold_positions = data.map { |(r0, h0, r1, category, score)| [0,1,2,3,4].select { |i| h0[i] == 'x' } }
    scores = data.map { |(r0, h0, r1, category, score)| score }
    FakeUI.new(self, categories, hold_positions, scores)
  end

  def prepare_fake_dice_roller(data)
    rolls = data.map { |(r0, h0, r1, category, score)| r0 + r1 }.flatten
    FakeDiceRoller.new(rolls)
  end
end

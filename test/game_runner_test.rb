require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    def initialize(categories, hold_positions)
      @categories = categories
      @hold_positions = hold_positions
      @output = []
    end

    def display_winner(player)
      @output << "#{player.name} won with #{player.score} points!"
    end

    def display_roll(roll)
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
      [[1,2,6,4,5], 'xx_xx', [3], 'chance'],          # 15
      [[1,1,1,1,1], 'xxxxx', [],  'yahtzee'],         # 50
      [[1,1,1,1,1], 'xxxxx', [],  'ones'],            # 5
      [[1,1,1,1,1], 'xxxxx', [],  'twos'],            # 0
      [[1,1,1,1,1], 'xxxxx', [],  'threes'],          # 0
      [[1,1,1,1,1], 'xxxxx', [],  'fours'],           # 0
      [[1,1,1,1,1], 'xxxxx', [],  'fives'],           # 0
      [[1,1,1,1,1], 'xxxxx', [],  'sixes'],           # 0
      [[1,1,1,1,1], 'xxxxx', [],  'pair'],            # 0
      [[1,1,1,1,1], 'xxxxx', [],  'two_pairs'],       # 0
      [[1,1,1,1,1], 'xxxxx', [],  'three_of_a_kind'], # 0
      [[1,1,1,1,1], 'xxxxx', [],  'four_of_a_kind'],  # 0
      [[1,1,1,1,1], 'xxxxx', [],  'small_straight'],  # 0
      [[1,1,1,1,1], 'xxxxx', [],  'large_straight'],  # 0
      [[1,1,1,1,1], 'xxxxx', [],  'full_house'],      # 0
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
    categories = data.map { |(r0, h0, r1, category)| category }
    hold_positions = data.map { |(r0, h0, r1, category)| [0,1,2,3,4].select { |i| h0[i] == 'x' } }
    FakeUI.new(categories, hold_positions)
  end

  def prepare_fake_dice_roller(data)
    rolls = data.map { |(r0, h0, r1, category)| r0 + r1 }.flatten
    FakeDiceRoller.new(rolls)
  end
end

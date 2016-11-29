require_relative 'test_helper'

class GameRunnerTest < Minitest::Test
  class FakeUI
    def initialize(categories)
      @categories = categories
      @output = []
    end

    def display_winner(player)
      @output << "#{player.name} won with #{player.score} points!"
    end

    def last_output
      @output.last
    end

    def ask_for_category
      @categories.shift
    end
  end

  def test_complete_game
    skip
    data = [
      [[1,2,3,4,5], 'chance'],          # 15
      [[1,1,1,1,1], 'yahtzee'],         # 50
      [[1,1,1,1,1], 'ones'],            # 5
      [[1,1,1,1,1], 'twos'],            # 0
      [[1,1,1,1,1], 'threes'],          # 0
      [[1,1,1,1,1], 'fours'],           # 0
      [[1,1,1,1,1], 'fives'],           # 0
      [[1,1,1,1,1], 'sixes'],           # 0
      [[1,1,1,1,1], 'pair'],            # 0
      [[1,1,1,1,1], 'two_pairs'],       # 0
      [[1,1,1,1,1], 'three_of_a_kind'], # 0
      [[1,1,1,1,1], 'four_of_a_kind'],  # 0
      [[1,1,1,1,1], 'small_straight'],  # 0
      [[1,1,1,1,1], 'large_straight'],  # 0
      [[1,1,1,1,1], 'full_house'],      # 0
    ]

    dice_roller = prepare_fake_dice_roller(data)
    player = Player.new('p', dice_roller)
    game = Game.new([player])
    ui = prepare_ui(data)

    runner = GameRunner.new(game, ui)
    runner.run
    assert_equal "Player 1 won with 70 points!", ui.last_output
  end

  private

  def prepare_ui(data)
    categories = data.map { |(_, category)| category }
    ui = FakeUI.new(categories)
  end

  def prepare_fake_dice_roller(data)
    todo('continue_from_here')
    FakeDiceRoller.new([])
  end
end

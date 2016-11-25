require_relative 'test_helper'
require_relative '../lib/game_runner'

class GameRunnerTest < Minitest::Test
  class FakeUI
    def initialize
      @output = []
    end

    def get_number_of_players
      1
    end

    def display_winner(player)
      @output << "#{player.name} won"
    end

    def last_output
      @output.last
    end

    def ask_for_category
      @categories ||= ScoreCalculator::CATEGORIES.dup
      @categories.shift
    end
  end

  def test_complete_game
    ui = FakeUI.new
    runner = GameRunner.new(ui)
    runner.run
    assert_equal "Player 1 won", ui.last_output
  end
end

require_relative 'game_wrapper'

class GameRunner
  def initialize(game_wrapper, ui)
    @game_wrapper = game_wrapper
    @ui           = ui
  end

  def run
    @ui.run(@game_wrapper)
  end
end

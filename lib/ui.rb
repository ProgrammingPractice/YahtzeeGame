require 'remedy'

class UI
  include Remedy

  def get_number_of_players
    viewport = Viewport.new
    interaction = Interaction.new

    title = "Number of players"
    players_count = 1

    viewport.draw Content.new([title, players_count.to_s])

    interaction.loop do |key|
      if key.to_s == 'up'
        players_count += 1
      end
      if key.to_s == 'down'
        players_count = [1, players_count - 1].max
      end
      if key.to_s == 'control_m'
        break
      end

      viewport.draw Content.new([title, players_count.to_s])
    end

    players_count
  end
end

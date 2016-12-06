require 'remedy'

class UI
  include Remedy

  def initialize
    @viewport = Viewport.new
  end

  def get_number_of_players
    interaction = Interaction.new

    title = "Number of players"
    players_count = 1

    @viewport.draw Content.new([title, players_count.to_s])

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

      @viewport.draw Content.new([title, players_count.to_s])
    end

    players_count
  end

  def start_of_player_turn(player)
    @player = player
  end

  def display_roll(roll)
    @roll = roll
  end

  def ask_for_hold_positions
    template = "#{@player.name}
You rolled: #{@roll.inspect}
Select what to hold:
%{hold_pattern}










Use arrows to move around. Space to select. Enter to accept.
"

    hold_pattern = [0,0,0,0,0]
    cursor = 0

    message = template % { hold_pattern: hold_pattern.join() }
    @viewport.draw(Content.new([message]))

    Interaction.new.loop do |key|
      if key.to_s == 'right'
        cursor = (cursor + 1) % 5
      end
      if key.to_s == 'left'
        cursor = (cursor - 1) % 5
      end
      if key.to_s == 'control_m'
        break
      end
      if key.to_s == 'space'
        hold_pattern[cursor] = (hold_pattern[cursor] + 1) % 2
      end

      message = template % { hold_pattern: hold_pattern.join() }
      @viewport.draw(Content.new([message]))
    end

    hold_positions = (0..4).select { |i| hold_pattern[i] == 1 }
  end

  def ask_for_category
    puts 'TODO'
    exit
  end
end

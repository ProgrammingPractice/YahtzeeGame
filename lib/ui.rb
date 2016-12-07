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
    Remedy::ANSI.cursor.show!

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
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(3))
    Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))

    Remedy::Keyboard.raise_on_control_c!
    loop do
      key = Remedy::Keyboard.get

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
      Remedy::ANSI.cursor.home!
      Remedy::ANSI.push(Remedy::ANSI.cursor.down(3))
      Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))
    end
    ANSI.screen.safe_reset!

    hold_positions = (0..4).select { |i| hold_pattern[i] == 1 }
  end

  def ask_for_category
    categories = @player.categories
    template = "Please select category for roll: #{@roll.inspect}
#{categories}
"

    cursor = 0

    message = "#{template}\n#{cursor}"
    @viewport.draw(Content.new([message]))

    Interaction.new.loop do |key|
      if key.to_s == 'down'
        cursor = (cursor + 1) % categories.size
      end
      if key.to_s == 'up'
        cursor = (cursor - 1) % categories.size
      end
      if key.to_s == 'control_m'
        break
      end

      message = "#{template}\n#{cursor}"
      @viewport.draw(Content.new([message]))
    end
    Remedy::ANSI.cursor.show!

    category = categories[cursor]
  end

  def end_of_player_turn(player)
  end

  def display_winner(winners)
    puts "The winners are: #{winners.map(&:name).join(' & ')}"
    puts "Congratulations!"
  end
end

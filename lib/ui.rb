require 'remedy'

class UI
  include Remedy

  def start_of_player_turn(player)
    @player = player
  end

  def display_roll(roll)
    @roll = roll
  end

  def ask_for_number_of_players
    title = "Number of players"
    players_count = 1

    Viewport.new.draw Content.new([title, players_count.to_s])

    interaction_loop do |key|
      if key.to_s == 'up'
        players_count += 1
      end
      if key.to_s == 'down'
        players_count = [1, players_count - 1].max
      end
      if key.to_s == 'control_m'
        break
      end

      Viewport.new.draw Content.new([title, players_count.to_s])
    end

    players_count
  end

  def ask_for_hold_positions
    template = "#{@player.name}
      You rolled: #{@roll.inspect}
      Select what to hold:
      %{hold_pattern}










      Use arrows to move around. Space to select. Enter to accept.
    ".gsub(/^\s+/, '')

    hold_pattern = [0,0,0,0,0]
    cursor = 0

    message = template % { hold_pattern: hold_pattern.join() }
    Viewport.new.draw(Content.new([message]))
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(3))
    Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))

    interaction_loop do |key|
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
      Viewport.new.draw(Content.new([message]))
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
    Viewport.new.draw(Content.new([message]))

    interaction_loop do |key|
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
      Viewport.new.draw(Content.new([message]))
    end

    category = categories[cursor]
  end

  def end_of_player_turn(player)
  end

  def display_winner(winners)
    puts "The winners are: #{winners.map(&:name).join(' & ')}"
    puts "Congratulations!"
  end

  private

  def interaction_loop
    Remedy::Keyboard.raise_on_control_c!
    loop do
      key = Remedy::Keyboard.get

      if key.to_s == 'q'
        puts "Bye"
        exit
      end

      yield(key)
    end
  end
end

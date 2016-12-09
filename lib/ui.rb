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
    players_count = 1

    display = -> { display_players_count(players_count) }
    commands = {
      'up'   => -> { players_count += 1 },
      'down' => -> { players_count = [1, players_count - 1].max }
    }

    smart_interaction_loop(display, commands)

    players_count
  end

  def ask_for_hold_positions
    hold_pattern = [0,0,0,0,0]
    cursor = 0

    display = -> { display_hold(cursor, hold_pattern) }
    commands = {
      'right' => -> { cursor = (cursor + 1) % 5 },
      'left'  => -> { cursor = (cursor - 1) % 5 },
      'space' => -> { hold_pattern[cursor] = (hold_pattern[cursor] + 1) % 2 },
    }

    smart_interaction_loop(display, commands)

    ANSI.screen.safe_reset!

    (0..4).select { |i| hold_pattern[i] == 1 }
  end

  def ask_for_category
    categories = @player.categories

    cursor = 0

    display = -> { display_categories(categories, cursor) }
    commands = {
      'down' => -> { cursor = (cursor + 1) % categories.size },
      'up'   => -> { cursor = (cursor - 1) % categories.size }
    }

    smart_interaction_loop(display, commands)

    categories[cursor]
  end

  def end_of_player_turn(player)
    # nothing
  end

  def display_winner(winners)
    puts "The winners are: #{winners.map(&:name).join(' & ')}"
    puts "Congratulations!"
  end

  private

  def smart_interaction_loop(display, commands)
    display.call
    interaction_loop do |key|
      if commands.key?(key.to_s)
        commands[key.to_s].call
      end
      if key.to_s == 'control_m'
        break
      end
      display.call
    end
  end

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

  def display_players_count(players_count)
    title = "Number of players"
    Viewport.new.draw Content.new([title, players_count.to_s])
  end

  def display_hold(cursor, hold_pattern)
    template = "#{@player.name}
      You rolled: #{@roll.inspect}
      Select what to hold:
      %{hold_pattern}


      Use arrows to move around. Space to select. Enter to accept.
    ".gsub(/^\s+/, '')

    message = template % { hold_pattern: hold_pattern.join() }
    Viewport.new.draw(Content.new([message]))
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(3))
    Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))
  end

  def display_categories(categories, cursor)
    template = "Please select category for roll: #{@roll.inspect}
      #{categories}
    "
    message = "#{template}\n#{cursor}"
    Viewport.new.draw(Content.new([message]))
  end
end

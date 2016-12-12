require 'remedy'

class UI
  KEY_ENTER = 'control_m'

  def start_of_player_turn(player)
    @player = player
    @rolls_count = 0
  end

  def display_roll(roll)
    @roll = roll
    @rolls_count += 1
    # we do the actual display in 'ask_for_category'
  end

  def ask_for_number_of_players
    players_count = 1

    display = -> { display_players_count(players_count) }
    commands = {
      'up'   => -> { players_count += 1 },
      'down' => -> { players_count = [1, players_count - 1].max }
    }

    interaction_loop(display, commands)

    players_count
  end

  def ask_for_hold_positions
    cursor       = 0
    hold_pattern = [1,1,1,1,1]

    display = -> { display_hold(cursor, hold_pattern) }
    commands = {
      'right' => -> { cursor = (cursor + 1) % 5 },
      'left'  => -> { cursor = (cursor - 1) % 5 },
      'space' => -> { hold_pattern[cursor] = (hold_pattern[cursor] + 1) % 2 },
    }

    interaction_loop(display, commands)

    (0..4).select { |i| hold_pattern[i] == 1 }
  end

  def ask_for_category
    categories = @player.categories
    index      = 0

    display = -> { display_categories(categories, index) }
    commands = {
      'down' => -> { index = (index + 1) % categories.size },
      'up'   => -> { index = (index - 1) % categories.size }
    }

    interaction_loop(display, commands)

    categories[index]
  end

  def end_of_player_turn(player)
    # nothing
  end

  def display_winners(winners)
    score = winners.first.score
    if winners.size == 1
      puts "The winner is: #{winners.first.name} with score #{score}!"
    else
      puts "The winners are: #{winners.map(&:name).join(' & ')} with score #{score}!"
    end
    puts "Congratulations!"
  end

  private

  def interaction_loop(display, commands)
    display.call

    Remedy::Keyboard.raise_on_control_c!
    loop do
      key = Remedy::Keyboard.get.to_s

      if key == 'q'
        puts "Bye"
        exit
      elsif key == KEY_ENTER
        break
      elsif commands.key?(key)
        commands.fetch(key).call
      end

      display.call
    end
  end

  def display_players_count(players_count)
    header = Remedy::Header.new(["Yahtzee!\nSelect number of players"])
    footer = Remedy::Footer.new(["--------\nUse up/down to change values. Enter to accept."])

    Remedy::Viewport.new.draw(Remedy::Content.new([players_count.to_s]), Remedy::Size.new(0,0), header, footer)
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(2))
  end

  def display_hold(cursor, hold_pattern)
    dice_to_hold = hold_pattern.each_with_index.map do |value, i|
      value == 0 ? '-' : @roll[i]
    end.join

    message = "
      You rolled: #{@roll.inspect} (roll #{@rolls_count}/3)
      Select what to hold:
      #{dice_to_hold}
    ".gsub(/^\s+/, '')

    footer = Remedy::Footer.new(["--------\nUse left/right to move around. Space to mark position. Enter to accept."])

    Remedy::Viewport.new.draw(Remedy::Content.new([message]), Remedy::Size.new(0,0), header, footer)
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(3))
    Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))
  end

  def display_categories(categories, index)
    category_names = categories.map do |category|
      category.gsub(/_/, " ").capitalize
    end

    message = "Please select category for roll: #{@roll.inspect}
      #{category_names.join("\n")}
    ".gsub(/^\s+/, '')

    footer = Remedy::Footer.new(["--------\nUse up/down to move around. Enter to accept."])

    Remedy::Viewport.new.draw(Remedy::Content.new([message]), Remedy::Size.new(0,0), header, footer)
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(index+2))
  end

  def header
    Remedy::Header.new(["#{@player.name} Current score: #{@player.score}"])
  end
end

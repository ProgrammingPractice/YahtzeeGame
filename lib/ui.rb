require 'remedy'

class UI
  KEY_ENTER = 'control_m'.freeze

  def initialize(game_wrapper)
    @game_wrapper = game_wrapper

    @players = game_wrapper.players
  end

  def run
    loop do
      ui_action = @game_wrapper.next_step

      if ui_action.is_a?(GameWrapper::AskForHoldPositionsAction)
        input_from_user = ask_for_hold_positions(ui_action.roll, ui_action.player, ui_action.rolls_count)
      elsif ui_action.is_a?(GameWrapper::AskForCategoryAction)
        input_from_user = ask_for_category(ui_action.roll, ui_action.player)
      else
        raise "Unknown action: #{ui_action.inspect}"
      end

      @game_wrapper.advance(input_from_user)

      end_of_step_hook

      break unless @game_wrapper.rounds_left?
    end

    display_winners(@game_wrapper.winners)
  end

  def end_of_step_hook
    if @game_wrapper.round_finished?
      @game_wrapper.advance_to_next_player

      end_of_player_turn_assertions
    end
  end

  def end_of_player_turn_assertions; end

  # def ask_for_number_of_players
  #   players_count = 1

  #   display = -> { display_players_count(players_count) }
  #   commands = {
  #     'up'   => -> { players_count += 1 },
  #     'down' => -> { players_count = [1, players_count - 1].max }
  #   }

  #   interaction_loop(display, commands)

  #   players_count
  # end

  def ask_for_hold_positions(roll, player, rolls_count)
    cursor       = 0
    hold_pattern = [1,1,1,1,1]

    display = -> { display_hold(roll, cursor, hold_pattern, player, rolls_count) }
    commands = {
      'right' => -> { cursor = (cursor + 1) % 5 },
      'left'  => -> { cursor = (cursor - 1) % 5 },
      'space' => -> { hold_pattern[cursor] = (hold_pattern[cursor] + 1) % 2 },
    }

    interaction_loop(display, commands)

    (0..4).select { |i| hold_pattern[i] == 1 }
  end

  def ask_for_category(roll, player)
    players = @players

    index = 0

    display = -> { display_categories(index, roll, players, player) }
    commands = {
      'down' => -> { index = (index + 1) % categories(player).size },
      'up'   => -> { index = (index - 1) % categories(player).size }
    }

    interaction_loop(display, commands)

    categories(player)[index]
  end

  # def display_winners(winners)
  #   score = winners.first.score
  #   if winners.size == 1
  #     puts "The winner is: #{winners.first.name} with score #{score}!"
  #   else
  #     puts "The winners are: #{winners.map(&:name).join(' & ')} with score #{score}!"
  #   end
  #   puts "Congratulations!"
  # end

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

  # def display_players_count(players_count)
  #   header = Remedy::Header.new(["Yahtzee!\nSelect number of players"])
  #   footer = Remedy::Footer.new(["--------\nUse up/down to change values. Enter to accept."])

  #   Remedy::Viewport.new.draw(Remedy::Content.new([players_count.to_s]), Remedy::Size.new(0,0), header, footer)
  #   Remedy::ANSI.cursor.home!
  #   Remedy::ANSI.push(Remedy::ANSI.cursor.down(2))
  # end

  def display_hold(roll, cursor, hold_pattern, player, rolls_count)
    dice_to_hold = hold_pattern.each_with_index.map do |value, i|
      value == 0 ? '-' : roll[i]
    end.join

    message = "
      You rolled: #{roll.inspect} (roll #{rolls_count}/3)
      Select what to hold:
      #{dice_to_hold}
      --------
      Available categories:
      #{category_names(player).join("\n")}
    ".gsub(/^\s+/, '')

    footer = Remedy::Footer.new(["--------\nUse left/right to move around. Space to mark position. Enter to accept."])

    Remedy::Viewport.new.draw(Remedy::Content.new([message]), Remedy::Size.new(0,0), header(player), footer)
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(@players.size + 4))
    Remedy::ANSI.push(Remedy::ANSI.cursor.to_column(cursor + 1))
  end

  def display_categories(index, roll, players, player)
    message = "Please select category for roll: #{roll.inspect}
      #{category_names(player).join("\n")}
    ".gsub(/^\s+/, '')

    footer = Remedy::Footer.new(["--------\nUse up/down to move around. Enter to accept."])

    Remedy::Viewport.new.draw(Remedy::Content.new([message]), Remedy::Size.new(0,0), header(player), footer)
    Remedy::ANSI.cursor.home!
    Remedy::ANSI.push(Remedy::ANSI.cursor.down(players.size + index + 3))
  end

  def header(player)
    message = @players.map do |player|
      "#{player.name}: #{player.score} points"
    end.join("\n")

    Remedy::Header.new([message, '--------', "Playing -> #{player.name}"])
  end

  def categories(player)
    player.categories
  end

  def category_names(player)
    categories(player).map do |category|
      category.gsub(/_/, " ").capitalize
    end
  end
end

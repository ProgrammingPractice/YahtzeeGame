#! /usr/bin/env ruby

require_relative 'yahtzee_game'

game = YahtzeeGame.new

def display_roll(roll)
  puts "You rolled: ", roll.inspect
end

def user_selects_category(game)
  puts "Please select the category for this roll ^^"
  puts game.categories
  'chance'
end

def display_score(score)
  puts "The score is #{score}"
end

game.roll_dice
display_roll(game.roll)
category = user_selects_category(game)
game.place_in_category_and_calculate_score(category)
display_score(game.score)

require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'

$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
$LOAD_PATH.unshift(File.expand_path('..', __FILE__))

require 'fake_dice_roller'

require 'dice_roller'
require 'game'
require 'game_wrapper'
require 'player'

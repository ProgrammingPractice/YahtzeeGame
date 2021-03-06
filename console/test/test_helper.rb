require 'minitest/autorun'
require 'minitest/pride'
require 'byebug'

$LOAD_PATH.unshift(File.expand_path('../../core/lib', __dir__))
$LOAD_PATH.unshift(File.expand_path('../../core/test', __dir__))
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
$LOAD_PATH.unshift(__dir__)

require 'helpers/fake_dice_roller'

require 'dice_roller'
require 'game'
require 'game_wrapper'
require 'player'

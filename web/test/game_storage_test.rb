require 'minitest/autorun'
require 'minitest/pride'
require '../lib/game_storage.rb'

class GameStorageTest < Minitest::Test
  #TODO Wite tests to drive development of spiked storage:
  # require 'json'

  # class GameStorage
    # DEFAULT_FILE = 'game_state.json'

    # def self.save(game)
    #   File.open(DEFAULT_FILE,"w") do |f|
    #     f.write({game.id => game.serialize}.to_json)
    #   end
    # end

    # def self.load(game_id)
    #   file = File.read(DEFAULT_FILE)
    #   json = JSON.parse(file)
    #   json[game_id]
    # end
  # end
end

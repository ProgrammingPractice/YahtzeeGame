require 'json'

module GameSerializer
  def self.dump(game)
    JSON.dump(players: game.players.map(&:to_h))
  end

  def self.load(data)
    players = JSON.load(data).fetch('players').map do |hash|
      Player.from_h(hash)
    end
    Game.new(players)
  end
end

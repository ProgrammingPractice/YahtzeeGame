require 'json'

module GameSerializer
  def self.dump(game)
    hash = { 'players' => [] }
    game.players.each do |player|
      hash['players'] << {
        'name'  => player.name,
        'score' => player.score,
        'categories' => player.categories
      }
    end
    JSON.dump(hash)
  end

  def self.load(data)
    players = []
    JSON.load(data).fetch('players').each do |hash|
      player = Player.new(hash.fetch('name'), nil)
      player.instance_variable_set(:@score, hash.fetch('score'))
      player.instance_variable_set(:@categories, hash.fetch('categories'))
      players << player
    end
    Game.new(players)
  end
end

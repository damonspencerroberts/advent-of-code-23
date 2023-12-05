require 'pry'
file_path = 'main-input.txt'
lines_array = File.readlines(file_path, chomp: true)

def generate_result(game)
  game, res = game.split(": ")
  _, id = game.split(" ").map(&:to_i)

  tracker = {
    "red" => [],
    "green" => [],
    "blue" => []
  }

  res.split("; ").map do |round|
    round.split(", ").map do |t|
      count, color = t.split(" ")
      tracker[color] << count.to_i
    end
  end

  tracker.values.map { |v| v.max }.inject(:*)
end

def cube_game_solver(games)
  ids = games.map do |game|
    generate_result(game)
  end

  ids.sum
end

test_games = [
  "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
  "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
  "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
  "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
  "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
]

# p cube_game_solver(test_games)
p cube_game_solver(lines_array)
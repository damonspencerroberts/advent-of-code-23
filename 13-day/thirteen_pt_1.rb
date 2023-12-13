require 'pry'

test_data = "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

class LavaReflection
  def initialize(data)
    @horizontal_grid, @vertical_grid = parse_data(data)
    @inflections = []
  end

  def run
    (0...@horizontal_grid.size).to_a.each do |i|
      find_inflection_point(@horizontal_grid[i], @vertical_grid[i])
    end

    @inflections.reduce(0) do |sum, inflection|
      if inflection[:direction] == :v
        sum += inflection[:value].first
      else
        sum += inflection[:value].first * 100
      end
    end
  end

  def find_inflection_point(horizontal_grid, vertical_grid)
    inflections = { h: {}, v: {} }
    horizontal_grid.each_with_index { |row, row_index| inflections[:h][row] ? inflections[:h][row] << row_index + 1 : inflections[:h][row] = [row_index + 1] }
    vertical_grid.each_with_index { |row, row_index| inflections[:v][row] ? inflections[:v][row] << row_index + 1 : inflections[:v][row] = [row_index + 1] }
    
    pair_count = { h: 0, v: 0 }
    inflections.entries.each do |entry|
      direction, inflection = entry
      pair_count[direction] = inflection.values.count { |v| v.size == 2 }
    end
    
    chosen = pair_count[:h] > pair_count[:v] ? :h : :v
    inflection_point = inflections[chosen].entries.select do |entry|
      key, value = entry
      has_consecutive_numbers(value)
    end

    @inflections << { direction: chosen, key: inflection_point.first.first, value: inflection_point.first.last }
  end

  def has_consecutive_numbers(array)
    array.sort.each_cons(2).any? { |a, b| b == a + 1 }
  end

  private

  def parse_data(data)
    grids = data.split("\n\n")

    horizontal = grids.map do |grid|
      grid.split("\n")
    end

    vertical = grids.map do |grid|
      grid.split("\n").map { |g| g.split('') }.transpose.map(&:join)
    end

    [horizontal, vertical]
  end
end

test_l = LavaReflection.new(test_data)
p test_l.run
# main_l = LavaReflection.new(File.read('main-input.txt'))
# p main_l.run
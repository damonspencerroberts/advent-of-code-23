require 'pry'

test_data ="...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."

class Galaxy
  def initialize(map)
    @grid = parse_data(map)
    @current_number = 1
    @grid_map = replace_with_nums
    @coords = get_coords_of_each_number
    @combinations = generate_combinations(@coords.keys.map(&:to_i).max)
  end

  def run
    @combinations.reduce(0) do |sum, combo|
      x, y = combo
      x1, y1 = @coords[x]
      x2, y2 = @coords[y]
      sum += (y2 - y1).abs + (x2 - x1).abs
    end
  end

  private

  def generate_combinations(n)
    numbers = (1..n).to_a
    combinations = numbers.combination(2).to_a
    combinations.map do |combo| 
      combo.map(&:to_s)
    end
  end

  def get_coords_of_each_number
    coords = {}
    @grid_map.each_with_index do |row, row_idx|
      row.split(/(\d+)/).map { |r| r.to_i > 0 ? r : r.split('') }
         .flatten
         .each_with_index do |char, col_idx|
        coords[char] = [col_idx + 1, row_idx + 1] if char != '.'
      end
    end
    coords
  end

  def replace_with_nums
    @grid.map! do |row|
      row.split('').map do |char|
        current_number = @current_number
        if char == '#'
          @current_number += 1
          current_number
        else
          char
        end
      end.join('')
    end
  end

  def parse_data(map)
    split_map = map.split("\n")
    newer_map = []
    split_map.each do |row|
      new_row = row.split('').all?('.') ? [row, row]: [row]
      newer_map << new_row
    end
    newest_map = []
    newer_map.flatten.map { |sm| sm.split('') }.transpose.each do |col|
      new_col = col.all?('.') ? [col, col] : [col]
      newest_map << new_col
    end
    final_map = []
    newest_map.each do |np|
      np.each do |c|
        final_map << c
      end
    end
    final_map.transpose.map(&:join)
  end
end

# test_galaxy = Galaxy.new(test_data)
main_galaxy = Galaxy.new(File.read('main-input.txt'))
p main_galaxy.run
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
    @empty_cols = []
    @empty_rows = []
    @grid = parse_data(map)
    @current_number = 1
    @grid_map = replace_with_nums
    @coords = get_coords_of_each_number
    @combinations = generate_combinations(@coords.keys.map(&:to_i).max)
  end

  def run(n)
    @combinations.reduce(0) do |sum, combo|
      x, y = combo
      x1, y1 = @coords[x]
      x2, y2 = @coords[y]
      x_max, x_min = [x1, x2].max, [x1, x2].min
      y_max, y_min = [y1, y2].max, [y1, y2].min
      
      x_sum = 0
      y_sum = 0
      @empty_cols.each do |col|
        x_sum += n - 1 if col.between?(x_min, x_max)
      end

      @empty_rows.each do |row|
        y_sum += n - 1 if row.between?(y_min, y_max)
      end
      
      sum += (y_max + x_sum - y_min) + (x_max + y_sum - x_min)
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
    split_map.each_with_index do |row, idx|
      @empty_rows << idx + 1 if row.split('').all?('.')
    end
    split_map = split_map.flatten.map { |sm| sm.split('') }.transpose.each_with_index do |col, idx|
      @empty_cols << idx + 1 if col.all?('.')
    end
    split_map.transpose.map(&:join)
  end
end

test_galaxy = Galaxy.new(test_data)
main_galaxy = Galaxy.new(File.read('main-input.txt'))
p main_galaxy.run(1_000_000)
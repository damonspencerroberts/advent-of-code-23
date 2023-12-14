require 'pry'

test_data = "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

class Boulder
  def initialize(data)
    @grid, @transposed_grid = parse_data(data)
  end

  def run
    boulder_crashing(@transposed_grid)
    @grid = @transposed_grid.map(&:reverse).transpose.map(&:join)
    @grid.each_with_index.reduce(0) do |sum, (row, idx)|
      os = row.chars.count('O')
      ld = row.chars.size - idx
      sum += os * ld
    end 
  end

  def boulder_crashing(grid)
    h = {}
    dup_grid = grid.dup
    dup_grid.each_with_index do |row, row_index|
      row.each_with_index do |column, column_index|
        h[row_index] ||= []
        h[row_index] << column_index if column == 'O'
      end
    end
    h.keys.each do |key|
      h[key].reverse.each do |value|
        dup_value = value
        loop do
          break unless dup_value + 1 < dup_grid.first.size

          if dup_grid[key][dup_value + 1] == '.'
            dup_grid[key][dup_value] = '.'
            dup_grid[key][dup_value + 1] = 'O'
            dup_value += 1
          else
            break
          end
        end
      end
    end
    dup_grid
  end

  private

  def parse_data(data)
    main = data.split("\n").map { |row| row.split('') }
    transposed = data.split("\n").map { |row| row.split('') }.transpose.map(&:reverse)
    [main, transposed]
  end
end

test_b = Boulder.new(test_data)
p test_b.run
main_b = Boulder.new(File.read('main-input.txt'))
p main_b.run
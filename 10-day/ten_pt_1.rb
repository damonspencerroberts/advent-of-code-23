require 'pry'

test_data = ".....
.S-7.
.|.|.
.L-J.
....."

test_data_two = "..F7.
.FJ|.
SJ.L7
|F--J
LJ..."

class MazeRunner
  def initialize(data)
    @grid = parse_data(data)
    @current_number = 0
    @current_positions = find_start_position
    @x_length = @grid[0].length
    @y_length = @grid.length
  end

  def run
    loop do
      @current_positions = find_next_positions
      
      break if @current_positions.empty?
    end

    @current_number
  end
  
  private

  def find_next_positions
    next_positions = []
    @current_positions.each do |tp|
      y = tp[0]
      x = tp[1]

      above, below, right, left = find_coordinates(y, x)
      if !above.nil? && above != "." && above != "S" && !above.is_a?(Integer)
        unless above.nil? || rules(y, x)[above][:a].nil?
          @grid[y - 1][x] = @current_number + 1
          next_positions << rules(y, x)[above][:a] 
        end
      end
      
      if !below.nil? && below != "." && below != "S" && !below.is_a?(Integer)
        unless below.nil? || rules(y, x)[below][:b].nil?
          @grid[y + 1][x] = @current_number + 1
          next_positions << rules(y, x)[below][:b] 
        end
      end
      
      if !right.nil? && right != "." && right != "S" && !right.is_a?(Integer)
        unless right.nil? || rules(y, x)[right][:r].nil?
          @grid[y][x + 1] = @current_number + 1
          next_positions << rules(y, x)[right][:r] 
        end
      end
      
      if !left.nil? && left != "." && left != "S" && !left.is_a?(Integer)
        unless left.nil? || rules(y, x)[left][:l].nil?
          @grid[y][x - 1] = @current_number + 1 + 1
          next_positions << rules(y, x)[left][:l]
        end
      end
    end

    @current_number += 1 unless next_positions.empty?
    next_positions
  end

  def find_coordinates(y, x)
    [
      y - 1 >= 0 ? @grid[y - 1][x] : nil,
      y + 1 < @y_length ? @grid[y + 1][x] : nil,
      x + 1 < @x_length ? @grid[y][x + 1] : nil,
      x - 1 >= 0 ? @grid[y][x - 1] : nil
    ]
  end

  def rules(y, x)
    above = [y - 1, x]
    below = [y + 1, x]
    right = [y, x + 1]
    left = [y, x - 1]
    {
      "F" => { a: above, l: left },
      "L" => { b: below, l: left },
      "7" => { a: above, r: right },
      "J" => { b: below, r: right },
      "|" => { a: above, b: below },
      "-" => { r: right, l: left },
    }
  end

  def find_start_position
    @grid.each_with_index do |row, y|
      row.each_with_index do |col, x|
        @grid[y][x] = 0 if col == "S"
        return [[y, x]] if col == "S"
      end
    end
  end

  def parse_data(data)
    d = data.split("\n")
    d.map { |row| row.split("") }
  end
end

test_runner_one = MazeRunner.new(test_data)
test_runner_two = MazeRunner.new(test_data_two)
runner = MazeRunner.new(File.read("main-input.txt"))
# p test_runner_one.run
# p '-----------------'
# p test_runner_two.run
# p '-----------------'
p runner.run

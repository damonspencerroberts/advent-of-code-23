require 'pry'

test_data = "???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"

class Spring
  def initialize(data)
    @grid = parse_data(data)
  end

  def run
    @grid.each_with_index.reduce(0) do |sum, (row, index)|
      p index
      p "---"
      z, v = row
      count = replace_all_possible(z, v)
      sum += count
    end
  end

  def replace_all_possible(nums, validation)
    count = 0
    generate_combinations(nums, validation).each do |combination|
      count += 1 if valid_combination?(combination, validation)
    end
    count
  end

  def generate_combinations(input, validation)
    question_mark_indices = input.each_char.with_index.select { |char, _| char == "?" }.map { |_, index| index }
  
    combinations = []
    (0..2**question_mark_indices.length - 1).each do |i|
      binary_representation = i.to_s(2).rjust(question_mark_indices.length, "0")
      combination = input.dup
  
      binary_representation.each_char.with_index do |bit, j|
        replacement = (bit == "0") ? "." : "#"
        combination[question_mark_indices[j]] = replacement
      end
  
      combinations << combination if valid_combination?(combination, validation)
    end
  
    combinations
  end

  def valid_combination?(combination, validation)
    counts = combination.split('.').reject(&:empty?).map(&:length)
    counts == validation
  end

  private

  def parse_data(data)
    data.split("\n").map { |row| parse_single_row(row) }
  end

  def parse_single_row(row)
    z, v = row.split(" ")
    z = ((z + "?") * 5).chomp!("?")
    v = (v.split(',').join * 5).split('').map(&:to_i)
    [z, v]
  end
end

test_spring = Spring.new(test_data)
p test_spring.run
# main_spring = Spring.new(File.read("main-input.txt"))
# p main_spring.run
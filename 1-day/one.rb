require 'pry'

file_path = 'main-input.txt'

lines_array = File.readlines(file_path, chomp: true)

def advent_puzzle(day_data)
  double_numbers = ["oneight", "twone", "threeight", "fiveight", "sevenine", "eightwo", "eighthree", "nineight"]
  numbers_spelled = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
  number_map = {
    "oneight" => [1, 8],
    "twone" => [2, 1],
    "threeight" => [3, 8],
    "fiveight" => [5, 8],
    "sevenine" => [7, 9],
    "eightwo" => [8, 2],
    "eighthree" => [8, 3],
    "nineight" => [9, 8],
    "one" => [1],
    "two" => [2],
    "three" => [3],
    "four" => [4],
    "five" => [5],
    "six" => [6],
    "seven" => [7],
    "eight" => [8],
    "nine" => [9],
  }
  pattern = Regexp.new(number_map.keys.join('|') + '|\d')
  sub_data = []
  final_data = []

  transformed_data = day_data.map! do |line|
    nums = line.scan(pattern)
    zip = nums.map do |num|
      if num.match?(/^((\+|-)?\d*\.?\d+)([eE](\+|-){1}\d+)?$/)
        num.to_i
      else
        number_map[num]
      end
    end
    zip.flatten
  end

  transformed_data.map do |nums|
    final_data << [nums.first, nums.last]
  end

  final_nums = final_data.map { |nums| nums.first.to_s + nums.last.to_s }.map(&:to_i)

  final_nums.sum
end

test_data = [
  "two1nine",
  "eightwothree",
  "abcone2threexyz",
  "xtwone3four",
  "4nineeightseven2",
  "zoneight234",
  "7pqrstsixteen"
]

# p advent_puzzle(test_data)

p advent_puzzle(lines_array)
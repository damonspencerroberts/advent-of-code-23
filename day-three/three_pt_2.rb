require 'pry'
require 'securerandom'

file_path = 'main-input.txt'
lines_array = File.readlines(file_path, chomp: true)

def generate_rows(arr, regex)
  rows = []
  arr.map do |s|
    el_with_index = []
    s.scan(regex) do |c|
      el_with_index << [c, $~.offset(0)[0]]
    end 

    el_with_index.map.with_index do |ni|
      el, index = ni
      live_indexes = (index..index + el.length - 1).to_a
      rows << { id: SecureRandom.uuid, el: el, indexes: live_indexes, row: arr.index(s) }
    end
  end
  rows
end

def engine_schematic_solver(schematics)
  number_rows = generate_rows(schematics, /\d+/)
  symbol_rows = generate_rows(schematics, /\*/)

  final_nums = []
  symbol_rows.each do |sr|
    on_the_right = number_rows.select { |nr| nr[:row] == sr[:row] && nr[:indexes].include?(sr[:indexes].last + 1) }
    on_the_left = number_rows.select { |nr| nr[:row] == sr[:row] && nr[:indexes].include?(sr[:indexes].first - 1) }

    if on_the_right.any? && on_the_left.any?
      right_num = on_the_right.first[:el]
      left_num = on_the_left.first[:el]
      final_nums << (right_num.to_i * left_num.to_i)
    end

    above = number_rows.select do |nr| 
      nr[:row] == sr[:row] - 1 && 
      (nr[:indexes].include?(sr[:indexes].first) || 
      nr[:indexes].include?(sr[:indexes].first - 1) ||
      nr[:indexes].include?(sr[:indexes].first + 1))
    end

    below = number_rows.select do |nr|
      nr[:row] == sr[:row] + 1 &&
      (nr[:indexes].include?(sr[:indexes].first) || 
      nr[:indexes].include?(sr[:indexes].first - 1) ||
      nr[:indexes].include?(sr[:indexes].first + 1))
    end

    if above.any? && below.any?
      above_num = above.first[:el]
      below_num = below.first[:el]
      final_nums << (above_num.to_i * below_num.to_i)
    end

    if above.size > 1
      final_product = above.reduce { |acc, nr| acc[:el].to_i * nr[:el].to_i }
      final_nums << final_product
    end

    if below.size > 1
      final_product = below.reduce { |acc, nr| acc[:el].to_i * nr[:el].to_i }
      final_nums << final_product
    end

    if (on_the_right.any? || on_the_left.any?) && (above.any? || below.any?)
      next_to_num = on_the_right.any? ? on_the_right.first[:el] : on_the_left.first[:el]
      
      above.each do |nr|
        final_nums << (nr[:el].to_i * next_to_num.to_i)
      end

      below.each do |nr|
        final_nums << (nr[:el].to_i * next_to_num.to_i)
      end
    end
  end

  final_nums.sum
end

test_data = [
  "467..114..",
  "...*......",
  "..35..633.",
  "......#...",
  "617*......",
  ".....+.58.",
  "..592.....",
  "......755.",
  "...$.*....",
  ".664.598.."
]
# p engine_schematic_solver(test_data) == 467835
p engine_schematic_solver(lines_array)
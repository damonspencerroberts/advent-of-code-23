require 'pry'
file_path = 'main-input.txt'
lines_array = File.readlines(file_path, chomp: true)

def generate_rows(arr, regex)
  rows = []
  arr.map do |s|
    el_with_index = []
    s.scan(regex) do |c|
      el_with_index << [c, $~.offset(0)[0]]
    end 

    el_with_index.map do |ni|
      el, index = ni
      live_indexes = (index..index + el.length - 1).to_a
      rows << { el: el, indexes: live_indexes, row: arr.index(s) }
    end
  end
  rows
end

def find_above_and_below(number_rows, symbol_rows, nums)
  number_rows.map.with_index do |nr, index|
    symbols_on_same_row = symbol_rows.select { |sr| sr[:row] == nr[:row] }
    
    if symbols_on_same_row.any?
      first = nr[:indexes].first
      last = nr[:indexes].last

      symbol_indexes = symbols_on_same_row.map { |sr| sr[:indexes] }.flatten
      nums << nr if symbol_indexes.include?(first - 1) || symbol_indexes.include?(last + 1)
    end

    above = symbol_rows.select { |sr| sr[:row] == nr[:row] - 1 }
    below = symbol_rows.select { |sr| sr[:row] == nr[:row] + 1 }

    next unless above || below
    if above.any?
      above.each do |a|
        above_symbol = a[:indexes].find { |i| nr[:indexes].include?(i) || nr[:indexes].include?(i + 1) || nr[:indexes].include?(i - 1) }
        nums << nr if above_symbol && !nums.include?(nr)
      end
    end
    
    if below.any?
      below.each do |b|
        below_symbol = b[:indexes].find { |i| nr[:indexes].include?(i) || nr[:indexes].include?(i + 1) || nr[:indexes].include?(i - 1) }
        nums << nr if below_symbol && !nums.include?(nr)
      end
    end
  end

  nums
end

def engine_schematic_solver(schematics)
  number_rows = generate_rows(schematics, /\d+/)
  symbol_rows = generate_rows(schematics, /[^a-zA-Z0-9.]/)

  cur_nums = []
  cur_nums = find_above_and_below(number_rows, symbol_rows, cur_nums)

  elements = cur_nums.map { |cn| cn[:el] }
  p elements
  elements.map(&:to_i).sum
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
# p engine_schematic_solver(test_data) == 4361
p engine_schematic_solver(lines_array)
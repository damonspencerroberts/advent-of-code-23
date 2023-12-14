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

# Part 1 26957
# Part 2 42695

# --- Day 13: Point of Incidence ---
# With your help, the hot springs team locates an appropriate spring which launches you neatly and precisely up to the edge of Lava Island.

# There's just one problem: you don't see any lava.

# You do see a lot of ash and igneous rock; there are even what look like gray mountains scattered around. After a while, you make your way to a nearby cluster of mountains only to discover that the valley between them is completely full of large mirrors. Most of the mirrors seem to be aligned in a consistent way; perhaps you should head in that direction?

# As you move through the valley of mirrors, you find that several of them have fallen from the large metal frames keeping them in place. The mirrors are extremely flat and shiny, and many of the fallen mirrors have lodged into the ash at strange angles. Because the terrain is all one color, it's hard to tell where it's safe to walk or where you're about to run into a mirror.

# You note down the patterns of ash (.) and rocks (#) that you see as you walk (your puzzle input); perhaps by carefully analyzing these patterns, you can figure out where the mirrors are!

# For example:

# #.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.

# #...##..#
# #....#..#
# ..##..###
# #####.##.
# #####.##.
# ..##..###
# #....#..#
# To find the reflection in each pattern, you need to find a perfect reflection across either a horizontal line between two rows or across a vertical line between two columns.

# In the first pattern, the reflection is across a vertical line between two columns; arrows on each of the two columns point at the line between the columns:

# 123456789
#     ><   
# #.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.
#     ><   
# 123456789
# In this pattern, the line of reflection is the vertical line between columns 5 and 6. Because the vertical line is not perfectly in the middle of the pattern, part of the pattern (column 1) has nowhere to reflect onto and can be ignored; every other column has a reflected column within the pattern and must match exactly: column 2 matches column 9, column 3 matches 8, 4 matches 7, and 5 matches 6.

# The second pattern reflects across a horizontal line instead:

# 1 #...##..# 1
# 2 #....#..# 2
# 3 ..##..### 3
# 4v#####.##.v4
# 5^#####.##.^5
# 6 ..##..### 6
# 7 #....#..# 7
# This pattern reflects across the horizontal line between rows 4 and 5. Row 1 would reflect with a hypothetical row 8, but since that's not in the pattern, row 1 doesn't need to match anything. The remaining rows match: row 2 matches row 7, row 3 matches row 6, and row 4 matches row 5.

# To summarize your pattern notes, add up the number of columns to the left of each vertical line of reflection; to that, also add 100 multiplied by the number of rows above each horizontal line of reflection. In the above example, the first pattern's vertical line has 5 columns to its left and the second pattern's horizontal line has 4 rows above it, a total of 405.

# Find the line of reflection in each of the patterns in your notes. What number do you get after summarizing all of your notes?

# Your puzzle answer was 26957.

# The first half of this puzzle is complete! It provides one gold star: *

# --- Part Two ---
# You resume walking through the valley of mirrors and - SMACK! - run directly into one. Hopefully nobody was watching, because that must have been pretty embarrassing.

# Upon closer inspection, you discover that every mirror has exactly one smudge: exactly one . or # should be the opposite type.

# In each pattern, you'll need to locate and fix the smudge that causes a different reflection line to be valid. (The old reflection line won't necessarily continue being valid after the smudge is fixed.)

# Here's the above example again:

# #.##..##.
# ..#.##.#.
# ##......#
# ##......#
# ..#.##.#.
# ..##..##.
# #.#.##.#.

# #...##..#
# #....#..#
# ..##..###
# #####.##.
# #####.##.
# ..##..###
# #....#..#
# The first pattern's smudge is in the top-left corner. If the top-left # were instead ., it would have a different, horizontal line of reflection:

# 1 ..##..##. 1
# 2 ..#.##.#. 2
# 3v##......#v3
# 4^##......#^4
# 5 ..#.##.#. 5
# 6 ..##..##. 6
# 7 #.#.##.#. 7
# With the smudge in the top-left corner repaired, a new horizontal line of reflection between rows 3 and 4 now exists. Row 7 has no corresponding reflected row and can be ignored, but every other row matches exactly: row 1 matches row 6, row 2 matches row 5, and row 3 matches row 4.

# In the second pattern, the smudge can be fixed by changing the fifth symbol on row 2 from . to #:

# 1v#...##..#v1
# 2^#...##..#^2
# 3 ..##..### 3
# 4 #####.##. 4
# 5 #####.##. 5
# 6 ..##..### 6
# 7 #....#..# 7
# Now, the pattern has a different horizontal line of reflection between rows 1 and 2.

# Summarize your notes as before, but instead use the new different reflection lines. In this example, the first pattern's new horizontal line has 3 rows above it and the second pattern's new horizontal line has 1 row above it, summarizing to the value 400.

# In each pattern, fix the smudge and find the different line of reflection. What number do you get after summarizing the new reflection line in each pattern in your notes?


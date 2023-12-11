require 'pry'

test_data = "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

class Oasis
  def initialize(data)
    @segments = parse_data(data)
    @seg_tree = @segments.dup
    @current_segment = nil
  end

  def run
    calc_seg_tree

    @seg_tree.reduce(0) do |sum, seg|
      num = seg.reduce(0) do |sum2, s|
        sum2 = s - sum2 
        sum2
      end
      sum += num
    end
  end

  private

  def last_seg_of_tree
    @seg_tree.map! { |s| s.map { |s2| s2.last } }
  end

  def reverse_seg_tree
    @seg_tree.map! { |seg| seg.reverse }
  end

  def calc_seg_tree
    @segments.each_with_index do |segment, index|
      @current_segment = segment.first
      loop do
        new_seg = @current_segment.each_cons(2).map { |a, b| a - b }
        @seg_tree[index] << new_seg
        @current_segment = new_seg

        break if @current_segment.all?(&:zero?)
      end
    end

    last_seg_of_tree
    reverse_seg_tree
  end

  def parse_data(data)
    data.split("\n").map do |line|
      [line.split(" ").map(&:to_i).reverse]
    end
  end
end

oasis = Oasis.new(test_data)
oasis_main = Oasis.new(File.read("main-input.txt"))
p oasis_main.run
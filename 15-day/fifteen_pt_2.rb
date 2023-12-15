require 'pry'

test_data_one = "HASH"
test_data_two = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

class HashAlgo
  def initialize(data)
    @strings = parse_data(data)
    @boxes = {}
    @symbol_pattern = /(?:[a-zA-Z]{2})([-=])/
  end

  def run
    @strings.each_with_index do |str, idx|
      symbol = str.match(@symbol_pattern)[1]
      els = str.split(symbol)
      lets = els[0]
      box = hash_it(lets)
      @boxes[box] ||= { focal_pts: [], slots: [] }
      if symbol == "="
        focal_pt = els[1].to_i
        focal_pt_already_included = @boxes[box][:slots].include?(lets)
        if focal_pt_already_included
          lets_idx = @boxes[box][:slots].index(lets)
          @boxes[box][:focal_pts][lets_idx] = focal_pt
          @boxes[box][:slots][lets_idx] = lets
        else
          @boxes[box][:focal_pts] << focal_pt
          @boxes[box][:slots] << lets
        end
      elsif symbol == "-"
        focal_pt_already_included = @boxes[box][:slots].include?(lets)
        next unless focal_pt_already_included
        
        lets_idx = @boxes[box][:slots].index(lets)
        @boxes[box][:focal_pts].delete_at(lets_idx)
        @boxes[box][:slots].delete_at(lets_idx)
      end

      @boxes.delete(box) if @boxes[box][:slots].empty? && @boxes[box][:focal_pts].empty?
    end

    sum_arr = []
    @boxes.entries.each_with_index do |(box, value), idx|
      value[:focal_pts].each_with_index do |f_pt, i|
        sum_arr << (box + 1) * (i + 1) * (f_pt)
      end
    end
    sum_arr.sum
  end

  def hash_it(str)
    current_number = 0
    str.chars.each do |char|
      current_number += char.ord
      current_number = (current_number * 17) % 256
    end
    current_number
  end

  private

  def parse_data(data)
    data.split(',')
  end
end

# t_1 = HashAlgo.new(test_data_one)
# p t_1.run
# t_2 = HashAlgo.new(test_data_two)
# p t_2.run
m_t = HashAlgo.new(File.read('main-input.txt'))
p m_t.run
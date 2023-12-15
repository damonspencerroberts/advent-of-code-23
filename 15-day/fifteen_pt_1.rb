require 'pry'

test_data_one = "HASH"
test_data_two = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

class HashAlgo
  def initialize(data)
    @strings = parse_data(data)
    @current_number = 0
    @sums = []
  end

  def run
    @strings.each do |string|
      string.chars.each do |char|
        @current_number += char.ord
        @current_number = (@current_number * 17) % 256
      end
      @sums << @current_number
      @current_number = 0
    end
    @sums.sum
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
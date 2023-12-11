require 'pry'

test_data = "LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)"

class Node
  def initialize(data)
    @order, @values = parse_data(data)
    @starting_vals = @values.keys.select { |key| key.split("").last == 'A' }
    @current_value = nil
    @count = {}
  end

  def run
    gen_zzz
    p @count
    @count.values.reduce(&:lcm)
  end

  def gen_zzz
    @starting_vals.map do |value|
      @current_value = value
      loop do
        work_order(value)

        break if @current_value.split("").last == 'Z'
      end
    end
  end

  def work_order(value)
    @order.each do |cur|
      @current_value = @values[@current_value][ops[cur]]
      @count[value] = @count[value] ? @count[value] + 1 : 1
      next if @current_value.split("").last == 'Z'
    end
  end
  
  private

  def ops
    {
      'L' => 0,
      'R' => 1
    }
  end

  def parse_data(data)
    order = data.split("\n\n").first.split("")
    values = data.split("\n\n").last
    value_hash = values.split("\n").reduce({}) do |acc, value|
      main = value.split(" = ").first
      sub = value.split(" = ").last
      sub = sub.gsub(/[\(\)]/, "")
      sub = sub.split(", ")
      acc[main] = sub
      acc
    end
    [order, value_hash]
  end
end

new_node_test = Node.new(test_data)
new_node = Node.new(File.read("main-input.txt"))

p new_node.run


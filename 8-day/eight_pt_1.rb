require 'pry'

test_data = "LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)"

class Node
  def initialize(data)
    @order, @values = parse_data(data)
    @current_value = 'AAA'
    @count = 0
  end

  def run
    @order.each do |cur|
      new_value = @values[@current_value][ops[cur]]
      @current_value = new_value
      @count += 1
    end
    run unless @current_value == 'ZZZ'

    @count
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
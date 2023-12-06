require 'pry'

file_path = 'main-input.txt'
lines_text = File.read(file_path)

test_data = """Time:      7  15   30
Distance:  9  40  200
"""

class BoatRacer
  def initialize(data)
    @data = parse_data(data)
    @time = @data["Time"]
    @distance = @data["Distance"]
    @count = []
  end

  def run
    distances = self.find_distances
    @count.inject(:*)
  end
  
  private

  def parse_data(data)
    split_data = data.split("\n")
    split_data.reduce({}) do |acc, line|
      key, *values = line.split(":")
      acc[key] = values.map do |value| 
        value.split(" ").map(&:to_i) 
      end.flatten
      acc
    end
  end

  def find_distances
    @time.each_with_index do |time, index|
      count = 0
      times = (0..time).to_a.reverse
      times.each do |t|
        button_press = (t - time) * -1
        count += 1 if button_press * t > @distance[index]
      end
      @count << count
    end
  end
end


p BoatRacer.new(lines_text).run
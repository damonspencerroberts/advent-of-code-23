require 'pry'
file_path = 'main-input.txt'
lines_text = File.read(file_path)

test_data = "seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4"

START_TIME = Time.now

def convert_seconds_to_hms(seconds)
  hours = seconds / 3600
  minutes = (seconds % 3600) / 60
  seconds = seconds % 60

  formatted_time = format("%02d:%02d:%02d", hours, minutes, seconds)
  puts formatted_time
end

def record_time
  cur_time = Time.now
  convert_seconds_to_hms(cur_time - START_TIME)
end

def find_offset(seed, info)
  s = 0
  info['range'].each_with_index do |range,  idx|
    top_of_segment = info['start'][idx] + range - 1

    record_time
    if top_of_segment >= seed && seed >= info['start'][idx]
      x1, y1 = info['start'][idx], info['end'][idx]
      x2 = x1 + range - 1
      y2 = y1 + range - 1
      s = seed - x1 + y1
      break
    else
      s = seed
    end  
  end
  s
end

def split_lines(data)
  double_lines = data.split("\n\n")
  split_els = double_lines.map { |line| line.split("\n") }
  seeds = split_els.first.first.split(": ")[1].split(" ").map(&:to_i)
  final_info = {}

  split_els[1..-1].each do |line|
    info = {
      'end' => [],
      'start' => [],
      'range' => []
    }
    mapper = line[1..-1].map { |el| el.split(" ").map(&:to_i) }
    mapper.each do |row|
      d, s, r = row
      info['category'] = line.first.split(" map:").first
      info['end'] << d
      info['start'] << s
      info['range'] << r
    end
    final_info[line.first.split(" map:").first] = info
  end

  [seeds, final_info]
end


def order
  [
    'seed-to-soil', 
    'soil-to-fertilizer', 
    'fertilizer-to-water', 
    'water-to-light', 
    'light-to-temperature', 
    'temperature-to-humidity', 
    'humidity-to-location'
  ]
end

def generate(data)
  seeds, info = split_lines(data)
  answer = order.reduce(seeds) do |acc, key|
    acc.map do |seed|
      find_offset(seed, info[key])
    end
  end
  p answer
  answer.min
end

# p generate(test_data)
p generate(lines_text)
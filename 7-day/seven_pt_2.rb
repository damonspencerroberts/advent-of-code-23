require 'pry'

file_path = 'main-input.txt'
lines_array = File.read(file_path, chomp: true)

test_data = "32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483"

class Card
  attr_reader :face, :value

  def initialize(card)
    @face = card
    @value = values[card] 
  end

  private

  def values
    {
      'A' => 14,
      'K' => 13,
      'Q' => 12,
      'T' => 10,
      '9' => 9,
      '8' => 8,
      '7' => 7,
      '6' => 6,
      '5' => 5,
      '4' => 4,
      '3' => 3,
      '2' => 2,
      'J' => 1
    }
  end
end

class Hand
  attr_accessor :rank
  attr_reader :cards, :value, :order, :tallied, :hand_value, :id

  def initialize(cards, value, id)
    @rank = nil
    @id = id
    @cards = cards.map { |card| Card.new(card) }
    @value = value
    @order = @cards.map { |card| card.value }
    @cards_with_joker = calc_cards_with_joker
    @tallied = @cards_with_joker.tally
    @hand_value = calc_hand_value
  end

  private

  def calc_cards_with_joker
    joker_value = @cards.map(&:face).select { |f| f != 'J'}.tally.sort_by { |k, v| [-v, k] }.to_h.keys.first
    new_cards_with_joker = @cards.map { |card| card.face == 'J' ? joker_value : card.face }
    new_cards_with_joker
  end

  def calc_hand_value
    hand_value_generate
  end
  
  def hand_value_generate
    if @tallied.values.include?(5)
      { name: "Five of a Kind", value: 6 }
    elsif @tallied.values.include?(4)
      { name: "Four of a Kind", value: 5 }
    elsif @tallied.values.include?(3) && @tallied.values.include?(2)
      { name: "Full House", value: 4 }
    elsif @tallied.values.include?(3)
      { name: "Three of a Kind", value: 3 }
    elsif @tallied.values.include?(2) && @tallied.values.length == 3
      { name: "Two Pair", value: 2 }
    elsif @tallied.values.include?(2)
      { name: "One Pair", value: 1 }
    else
      { name: "High Card", value: 0 }
    end
  end
end

class CamelGame
  def initialize(data)
    @hands = data.split("\n").map.with_index do |line, index|
      Hand.new(line.split(" ").first.split(""), line.split(" ").last.to_i, index + 1)
    end
  end

  def run
    t = @hands.flatten
              .sort_by { |hand| hand.hand_value[:value] }
              .reverse
              .group_by { |a| a.hand_value[:value] }
              .values
              .map { |gt| compare_card_values(gt) }
              .flatten
    t.each_with_index { |x, i| x.rank = t.length - i }
    val = t.map { |x| x.rank * x.value }
    p val.sum
  end

  private

  def compare_card_values(array_of_hand_values)
    return array_of_hand_values if array_of_hand_values.length == 1
    
    array_of_hand_values.sort { |a, b| a.order <=> b.order }.reverse
  end
end

game1 = CamelGame.new(test_data)
game2 = CamelGame.new(lines_array)

game2.run
# frozen_string_literal: true

require "pry"

# A program
class Program
  attr_reader :states

  def initialize(states)
    @states = states
    @running = true
    @position = 0
  end

  def run
    step while running?
  end

  def step
    if value_at(position) == 99
      @running = false
    elsif value_at(position) == 1
      ap = position + 1
      bp = position + 2
      np = position + 3
      a = value_at(value_at(ap))
      b = value_at(value_at(bp))
      y = position
      next_location = value_at(np)
      states[next_location] = a + b
      @position += 4
    elsif value_at(position) == 2
      ap = position + 1
      bp = position + 2
      np = position + 3

      a = value_at(value_at(ap))
      b = value_at(value_at(bp))
      y = position
      next_location = value_at(np)
      states[next_location] = a * b
      @position += 4
    else
      @position += 1
    end
  end

  def sub(hsh)
    hsh.each do |k, v|
      states[k] = v
    end
  end

  def value_at(index)
    Integer(states[index])
  end

  private

  attr_accessor :position, :running

  def running?
    running
  end
end

def main(input = nil)
  max = 0
  (0..99).each do |one|
    (0..99).each do |two|
      program = Program.new(input)
      subs = { 1 => one, 2 => two }
      p [program.value_at(0), program.value_at(1), program.value_at(2)].join(" - ")
      program.sub(subs)
      begin
        program.run
        value = program.value_at(0)
        max = value if value > max
        return "Yes" if value == 19_690_720
      rescue TypeError => e
      end
    end
  end
  p max
end

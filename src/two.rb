# frozen_string_literal: true

require "pry"

# A set of Intcode instructions. Responsible for returning current
# values in the instruction set and and updating values at the request
# of others.
class Instructions
  def initialize(instructions)
    @instructions = instructions
  end

  def read_position(position)
    instructions[position]
  end

  def write_position(position, value)
    @instructions[position] = value
  end

  private

  attr_reader :instructions
end

# The interpreter that converts a subset of an Intcode instruction set
# into instructions.
class Operation
  EXECUTE = :execute
  TERMINATE = :terminate
  SKIP = :skip

  def initialize(instructions)
    @instructions = instructions
  end

  def action
    case opcode
    when 1, 2
      EXECUTE
    when 99
      TERMINATE
    else
      SKIP
    end
  end

  def position
    instructions[3]
  end

  def value
    instructions[1].send(operation, instructions[2])
  end

  private

  attr_reader :instructions

  def operation
    case opcode
    when 1
      :+
    when 2
      :*
    else
      raise NotImplementedError
    end
  end

  def opcode
    instructions[0]
  end
end
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

# frozen_string_literal: true

require "pry"

# A set of Intcode instructions. Responsible for returning current
# values in the instruction set and and updating values at the request
# of others.
class Instructions
  def initialize(instructions)
    @instructions = instructions
  end

  def [](position)
    instructions[position]
  end

  def []=(position, value)
    @instructions[position] = value
  end

  def size
    instructions.size
  end

  private

  attr_reader :instructions
end

# The interpreter that converts a subset of an Intcode instruction set
# into instructions.
class Operation
  def initialize(opcode_position, instructions)
    @opcode_position = opcode_position
    @instructions = instructions
  end

  def replacement_position
    instructions[opcode_position + 3]
  end

  def skip?
    ![1, 2, 99].include?(opcode)
  end

  def terminate?
    opcode == 99
  end

  def value
    operand1 = instructions[instructions[opcode_position + 1]]
    operand2 = instructions[instructions[opcode_position + 2]]

    operand1.send(operation, operand2)
  end

  private

  attr_reader :instructions
  attr_reader :opcode_position

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
    instructions[opcode_position]
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

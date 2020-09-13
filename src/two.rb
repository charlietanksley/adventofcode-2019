# frozen_string_literal: true

require "pry"

# How to run as part of https://adventofcode.com/2019/day/2
#
# $ pry -Isrc
#
# require "two"
# instructions = File.read("data/two_a.txt").split(",").map(&:to_i);
# program = IntcodeProgram.new(instructions);
# program.update_instructions(1, 12)
# program.update_instructions(2, 2)
# program.run
# program.output
#=> 574684

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

  def to_a
    instructions
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

  def opcode
    instructions[opcode_position]
  end

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
end

# The main touchpoint for an Intcode Program. Takes an instruction set
# (an array of integers) as input and returns an instruction set
# (array of integers) as output.
class IntcodeProgram
  attr_reader :instructions

  def initialize(instructions)
    @instructions = Instructions.new(instructions)
  end

  def output
    instructions[0]
  end

  def run
    position = 0
    instructions.size.times do
      operation = Operation.new(position, instructions)

      break if operation.terminate?

      if operation.skip?
        position += 1
      else
        instructions[operation.replacement_position] = operation.value
        position += 4
      end
    end
  end

  def update_instructions(location, value)
    instructions[location] = value
  end
end

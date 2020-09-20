# frozen_string_literal: true

require "pry"

# How to run as part of https://adventofcode.com/2019/day/2
#
# $ pry -Isrc
#
# require "two"
# program_instructions = File.read("data/two_a.txt").split(",").map(&:to_i)
# program = IntcodeProgram.new(program_instructions)
# program.update_noun(12)
# program.update_verb(2)
# program.run
# program.output
#=> 4462686

# How to run as part 2 of https://adventofcode.com/2019/day/2
#
# $ pry -Isrc
#
# require "two"
# program_instructions = File.read("data/two_a.txt").split(",").map(&:to_i);
# noun, verb = IntcodeProgram.find_noun_and_verb(program_instructions, 19_690_720)
# #=> [59, 36]
# 100 * noun + verb
# #=> 5936

# A set of Intcode memory. Responsible for returning current
# values in the instruction set and and updating values at the request
# of others.
class Memory
  def initialize(memory)
    @memory = memory
  end

  def [](position)
    memory[position]
  end

  def []=(position, value)
    @memory[position] = value
  end

  def size
    memory.size
  end

  def to_a
    memory
  end

  private

  attr_reader :memory
end

# The interpreter that converts a subset of an Intcode instruction set
# into instructions.
class Operation
  def initialize(opcode_position, memory)
    @opcode_position = opcode_position
    @memory = memory
  end

  def replacement_position
    memory[opcode_position + 3]
  end

  def skip?
    ![1, 2, 99].include?(opcode)
  end

  def terminate?
    opcode == 99
  end

  def value
    operand1 = memory[memory[opcode_position + 1]]
    operand2 = memory[memory[opcode_position + 2]]

    operand1.send(operation, operand2)
  end

  private

  attr_reader :memory
  attr_reader :opcode_position

  def opcode
    memory[opcode_position]
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
  def self.find_noun_and_verb(instructions, goal, noun_range = (0..99), verb_range = (0..99))
    noun_range.each do |noun|
      verb_range.each do |verb|
        working_instructions = instructions.dup

        program = new(working_instructions)
        program.update_noun(noun)
        program.update_verb(verb)
        program.run
        return [noun, verb] if program.output == goal
      end
    end
  end

  attr_reader :memory

  def initialize(memory)
    @memory = Memory.new(memory)
  end

  def output
    memory[0]
  end

  def memory_readout
    memory.to_a
  end

  def run
    position = 0
    memory.size.times do
      operation = Operation.new(position, memory)

      break if operation.terminate?

      if operation.skip?
        position += 1
      else
        memory[operation.replacement_position] = operation.value
        position += 4
      end
    end
  end

  def update_noun(noun)
    memory[1] = noun
  end

  def update_verb(verb)
    memory[2] = verb
  end
end

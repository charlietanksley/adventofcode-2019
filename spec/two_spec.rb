# frozen_string_literal: true

$LOAD_PATH.unshift("lib")

require "two"

RSpec.describe Memory do
  let(:instructions) { [0, 1, 2, nil] }
  subject { described_class.new(instructions) }

  it "can write a value to a position" do
    subject[0] = 1
    expect(subject[0]).to eq(1)
  end
end

RSpec.describe Operation do
  let(:operation) { described_class.new(position, instructions) }
  let(:instructions) { [1, 2, 3, 4, 5, 99, nil] }

  context "addition" do
    let(:position) { 0 }

    it "is neither a skip nor a terminate" do
      expect([operation.terminate?, operation.skip?].all?).to be(false)
    end

    it "identifies the correct replacement_position for the update" do
      expect(operation.replacement_position).to eq(4)
    end

    it "identifies the correct value for the update" do
      expect(operation.value).to eq(7)
    end
  end

  context "multiplication" do
    let(:position) { 1 }

    it "is neither a skip nor a terminate" do
      expect([operation.terminate?, operation.skip?].all?).to be(false)
    end

    it "identifies the correct replacement_position for the update" do
      expect(operation.replacement_position).to eq(5)
    end

    it "identifies the correct value for the update" do
      expect(operation.value).to eq(20)
    end
  end

  context "skipping" do
    let(:position) { 2 }

    it "knows it is a `skip?` step" do
      expect(operation.skip?).to be_truthy
    end
  end

  context "terminating" do
    let(:position) { 5 }

    it "knows it is a `terminate?` step" do
      expect(operation.terminate?).to be_truthy
    end
  end
end

RSpec.describe IntcodeProgram do
  describe "program output" do
    it "returns an integer that is the program's output" do
      program = described_class.new([1, 1, 1, 4, 99, 5, 6, 0, 99])
      program.run
      expect(program.output).to eq(30)
    end
  end

  describe "finding unknown noun/verb combo" do
    it "determines the missing noun and verb" do
      program_instructions = File.read("data/two_a.txt").split(",").map(&:to_i)
      noun_and_verb = described_class.find_noun_and_verb(program_instructions, 19_690_720)
      expect(noun_and_verb).to eq([59, 36])
    end
  end

  context "regression tests" do
    {
      [1, 0, 0, 0, 99] => [2, 0, 0, 0, 99],
      [2, 3, 0, 3, 99] => [2, 3, 0, 6, 99],
      [2, 4, 4, 5, 99, 0] => [2, 4, 4, 5, 99, 9801],
      [1, 1, 1, 4, 99, 5, 6, 0, 99] => [30, 1, 1, 4, 2, 5, 6, 0, 99]
    }.each_pair do |instructions, expected_memory|
      it "converts #{instructions} to #{expected_memory}" do
        program = described_class.new(instructions)
        program.run
        updated_memory = program.memory_readout

        expect(updated_memory).to eq(expected_memory)
      end
    end
  end
end

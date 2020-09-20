# frozen_string_literal: true

require_relative "../src/two"

RSpec.describe Instructions do
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

    it "reports the action as 'execute'" do
      expect(operation.action).to eq(Operation::EXECUTE)
    end

    it "identifies the correct replacement_position for the update" do
      expect(operation.replacement_position).to eq(4)
    end

    it "identifies the correct value for the update" do
      expect(operation.value).to eq(5)
    end

    it "gracefully handles a nil value"
  end

  context "multiplication" do
    let(:position) { 1 }

    it "reports the action as 'execute'" do
      expect(operation.action).to eq(Operation::EXECUTE)
    end

    it "identifies the correct replacement_position for the update" do
      expect(operation.replacement_position).to eq(5)
    end

    it "identifies the correct value for the update" do
      expect(operation.value).to eq(12)
    end

    it "gracefully handles a nil value"
  end

  context "skipping" do
    let(:position) { 2 }

    it "reports the action as 'skip'" do
      expect(operation.action).to eq(Operation::SKIP)
    end
  end

  context "terminating" do
    let(:position) { 5 }

    it "reports the action as 'terminate'" do
      expect(operation.action).to eq(Operation::TERMINATE)
    end
  end
end

RSpec.describe Program do
  context "regression tests" do
    {
      [1, 0, 0, 0, 99] => [2, 0, 0, 0, 99],
      [2, 3, 0, 3, 99] => [2, 3, 0, 6, 99],
      [2, 4, 4, 5, 99, 0] => [2, 4, 4, 5, 99, 9801],
      [1, 1, 1, 4, 99, 5, 6, 0, 99] => [30, 1, 1, 4, 2, 5, 6, 0, 99]
    }.each_pair do |instructions, output|
      it "converts #{instructions} to #{output}" do
        program = Program.new(instructions)
        program.run

        expect(output).to eq(program.states)
      end
    end
  end
end

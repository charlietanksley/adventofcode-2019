# frozen_string_literal: true

require_relative "../src/two"

RSpec.describe Instructions do
  let(:instructions) { [0, 1, 2, nil] }
  subject { described_class.new(instructions) }

  it "can read the value at a position" do
    expect(subject.read_position(0)).to eq(0)
  end

  it "can write a value to a position" do
    subject.write_position(0, 1)
    expect(subject.read_position(0)).to eq(1)
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

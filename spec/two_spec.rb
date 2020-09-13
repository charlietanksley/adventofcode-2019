# frozen_string_literal: true

require_relative "../src/two"

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

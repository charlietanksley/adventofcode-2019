# frozen_string_literal: true

require_relative "../src/two"

RSpec.describe Program do
  subject { Program.new(instructions) }

  before do
    subject.run
  end

  context "a simple addition program" do
    let(:instructions) { [1, 0, 0, 0, 99] }

    it "updates the state correctly" do
      expect(subject.states).to eq([2, 0, 0, 0, 99])
    end
  end

  context "a simple multiplication program" do
    let(:instructions) { [2, 3, 0, 3, 99] }
    it "updates the state correctly" do
      expect(subject.states).to eq([2, 3, 0, 6, 99])
    end
  end

  context "next" do
    let(:instructions) { [2, 4, 4, 5, 99, 0] }
    it "does" do
      expect(subject.states).to eq([2, 4, 4, 5, 99, 9801])
    end
  end

  context "again" do
    let(:instructions) { [1, 1, 1, 4, 99, 5, 6, 0, 99] }
    it "does" do
      expect(subject.states).to eq([30, 1, 1, 4, 2, 5, 6, 0, 99])
    end
  end
end

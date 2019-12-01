# frozen_string_literal: true

require_relative "../src/three"

RSpec.describe Wire do
  describe "tracing a path" do
    subject { described_class.new(instructions) }

    describe "straight up" do
      let(:instructions) { ["U4"] }

      it "reports the line correctly" do
        expect(subject.path).to eq([[0, 0],
                                    [0, 1],
                                    [0, 2],
                                    [0, 3],
                                    [0, 4]])
      end
    end

    describe "straight down" do
      let(:instructions) { ["D4"] }

      it "reports the line correctly" do
        expect(subject.path).to eq([[0, 0],
                                    [0, -1],
                                    [0, -2],
                                    [0, -3],
                                    [0, -4]])
      end
    end

    describe "straight right" do
      let(:instructions) { ["R4"] }
      it "reports the line correctly" do
        expect(subject.path).to eq([[0, 0],
                                    [1, 0],
                                    [2, 0],
                                    [3, 0],
                                    [4, 0]])
      end
    end

    describe "straight left" do
      let(:instructions) { ["L4"] }
      it "reports the line correctly" do
        expect(subject.path).to eq([[0, 0],
                                    [-1, 0],
                                    [-2, 0],
                                    [-3, 0],
                                    [-4, 0]])
      end
    end

    describe "with turns" do
      let(:instructions) { ["U4", "R5", "D3"] }

      it "reports the line correctly" do
        expect(subject.path).to eq([[0, 0],
                                    [0, 1],
                                    [0, 2],
                                    [0, 3],
                                    [0, 4],

                                    [1, 4],
                                    [2, 4],
                                    [3, 4],
                                    [4, 4],
                                    [5, 4],

                                    [5, 3],
                                    [5, 2],
                                    [5, 1]])
      end
    end
  end
end

RSpec.describe WireCrossing do
  let(:wire1) { Wire.new(nil, [[0, 0], [1, 1], [10, 20], [3, 4]]) }
  let(:wire2) { Wire.new(nil, [[0, 0], [1, 1], [10, 20], [5, 6]]) }

  subject { described_class.new(wire1, wire2) }

  it "knows all intersections" do
    expect(subject.intersections).to match_array([[1, 1], [10, 20]])
  end

  it "can find the closest intersection to a given point" do
    expect(subject.closest_intersection_distance([0, 0])).to eq(2)
    expect(subject.closest_intersection_distance([9, 15])).to eq(6)
  end
end

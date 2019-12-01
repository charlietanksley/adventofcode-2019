# frozen_string_literal: true

require "pry"
require "set"

# #
class WireCrossing
  def initialize(wire1, wire2)
    @wire1 = wire1
    @wire2 = wire2
  end

  def intersections
    @intersections ||= (Set.new(wire1.path) & Set.new(wire2.path))
                       .delete_if { |item| item == [0, 0] }
                       .to_a
  end

  def closest_intersection_distance_by_steps
    wire1_intersections_with_steps = wire1.path
                                          .map
                                          .with_index { |step, index| [step, index] }
                                          .filter { |step| intersections.include?(step[0]) }

    wire2_intersections_with_steps = wire2.path
                                          .map
                                          .with_index { |step, index| [step, index] }
                                          .filter { |step| intersections.include?(step[0]) }

    total_distance = Hash.new(0)
    intersections.each do |intersection|
      w1_distance = wire1_intersections_with_steps.find { |x| x[0] == intersection }[1]
      w2_distance = wire2_intersections_with_steps.find { |x| x[0] == intersection }[1]
      total_distance[intersection] = w1_distance + w2_distance
    end

    total_distance.values.sort
  end

  def closest_intersection_distance(point)
    closest = nil
    closest_distance = Float::INFINITY

    intersections.each do |intersection|
      distance = (point[0] - intersection[0]).abs + (point[1] - intersection[1]).abs
      if distance < closest_distance
        closest_distance = distance
        closest = intersection
      end
    end
    closest_distance
  end

  private

  attr_reader :wire1, :wire2
end

# A wire that traces a line of points
class Wire
  attr_reader :instructions
  attr_accessor :traced_path

  def initialize(instructions = nil, path = nil)
    @instructions = instructions
    @traced_path = Path.start([0, 0])
    @path = path
  end

  def path
    @path ||= trace_path.path
  end

  private

  def trace_path
    instructions.each do |instruction|
      traced_path.extend(instruction)
    end

    traced_path
  end
end

# A path
class Path
  attr_reader :path

  def self.start(position)
    new([position])
  end

  def initialize(path)
    @path = path
  end

  def extend(instruction)
    direction = instruction[0]
    length = Integer(instruction[1..-1])

    starting_point = path.last

    move = {
      "U" => Up.new(starting_point, length),
      "D" => Down.new(starting_point, length),
      "R" => Right.new(starting_point, length),
      "L" => Left.new(starting_point, length)
    }[direction]

    add(move.walk)
  end

  def add(steps)
    @path = @path.concat(steps)
  end
end

# #
class Direction
  attr_reader :length, :starting_point

  def initialize(starting_point, length)
    @starting_point = starting_point
    @length = length
  end

  def walk
    raise NotImplemented
  end

  def steps
    (1..length).each
  end
end

# #
class Up < Direction
  def walk
    steps.with_object([]) do |magnitude, acc|
      acc << [starting_point[0], starting_point[1] + magnitude]
    end
  end
end

# #
class Down < Direction
  def walk
    steps.each.with_object([]) do |magnitude, acc|
      acc << [starting_point[0], starting_point[1] - magnitude]
    end
  end
end

# #
class Right < Direction
  def walk
    steps.each.with_object([]) do |magnitude, acc|
      acc << [starting_point[0] + magnitude, starting_point[1]]
    end
  end
end

# #
class Left < Direction
  def walk
    steps.each.with_object([]) do |magnitude, acc|
      acc << [starting_point[0] - magnitude, starting_point[1]]
    end
  end
end

def main(input)
  wire1 = Wire.new(input[0].split(","))
  wire2 = Wire.new(input[1].split(","))
  crossing = WireCrossing.new(wire1, wire2)
  crossing.closest_intersection_distance_by_steps
end

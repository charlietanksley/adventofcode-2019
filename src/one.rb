# frozen_string_literal: true

# Notes
# * `/` is floor division
# * Coerce to integer with Integer()

# IDK
class SpacecraftModule
  def initialize(mass)
    @mass = Integer(mass)
  end

  def fuel_requirement
    fuel = 0
    current_mass = mass.dup
    while fuel_required(current_mass).positive?
      fuel += fuel_required(current_mass)
      current_mass = fuel_required(current_mass)
    end

    fuel
  end

  private

  attr_reader :mass

  def fuel_required(current_mass)
    current_mass / 3 - 2
  end
end

# overall
class FuelCounterUpper
  def initialize(module_masses)
    @module_masses = module_masses
  end

  def fuel_required
    module_masses.inject(0) do |acc, mass|
      acc + SpacecraftModule.new(mass).fuel_requirement
    end
  end

  private

  attr_reader :module_masses
end

def main(input = nil)
  FuelCounterUpper.new(input).fuel_required
end

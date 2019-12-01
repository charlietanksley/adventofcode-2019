# frozen_string_literal: true

require_relative "../src/one"

RSpec.describe SpacecraftModule do
  describe "fuel calculations" do
    { 12 => 2,
      14 => 2,
      1969 => 966,
      100_756 => 50_346 }.each do |mass, fuel|
      it "calculates #{mass} correctly as #{fuel}" do
        spacecraft = SpacecraftModule.new(mass)
        expect(spacecraft.fuel_requirement).to eq(fuel)
      end
    end
  end
end

RSpec.describe FuelCounterUpper do
  it "correclty calculates fuel requirements for multiple spacecrafts" do
    counter = FuelCounterUpper.new([12, 14, 1969, 100_756])

    expect(counter.fuel_required).to eq(51_316)
  end
end

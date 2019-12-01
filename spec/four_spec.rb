# frozen_string_literal: true

require_relative "../src/four"

RSpec.describe Password do
  subject { Password.new(password) }

  describe "when all the checks pass" do
    let(:password) { 112233 }

    it "is a possible password" do
      expect(subject.possible?).to be true
    end
  end

  describe "when the digits decrease" do
    context "almost completely" do
      let(:password) { 300000 }

      it "is not a possible password" do
        expect(subject.possible?).to be false
      end
    end

    context "but mostly increase" do
      let(:password) { 223450 }

      it "is not a possible password" do
        expect(subject.possible?).to be false
      end
    end
  end

  describe "when no neighboring digits are equal" do
    let(:password) { 123789 }

    it "is not a possible password" do
      expect(subject.possible?).to be false
    end
  end

  describe "when there are consecutive matching digits" do
    describe "when no consecutive matches are longer than a pair" do
      let(:password) { 112233 }

      it "is a possible password" do
        expect(subject.possible?).to be true
      end
    end

    describe "when consecutive matches are longer than a pair" do
      let(:password) { 123444 }

      it "is a not possible password" do
        expect(subject.possible?).to be false
      end
    end
  end
end

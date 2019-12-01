# frozen_string_literal: true

require "pry"

# #
class Password
  def initialize(password)
    @password = password
  end

  def possible?
    increasing? && pair_of_repeats?
  end

  private

  attr_reader :password

  def digits
    # can't just use `#digits` because that sorts the digits
    password.to_s.split("").map(&:to_i)
  end

  def pair_of_repeats?
    consecutive_digits.any? { |count| count == 2 }
  end

  def consecutive_digits
    consecutive_digit_runs = []
    current_digit = nil
    current_digit_seen = nil
    digits.each do |digit|
      if digit == current_digit
        current_digit_seen += 1
      else
        consecutive_digit_runs.push(current_digit_seen)
        current_digit = digit
        current_digit_seen = 1
      end
    end
    consecutive_digit_runs.compact
  end

  def double_pair?
    digits
      .each_cons(2)
      .any? { |pair| pair[0] == pair[1] }
  end

  def no_matches_longer_than_pair?
    digits
      .each_cons(3)
      .none? { |pair| pair[0] == pair[1] && pair[1] == pair[2] }
  end

  def increasing?
    digits == digits.sort
  end
end

def main(range)
  # 538 is too low...
  range_start, range_end = range.split("-").map { |s| Integer(s) }
  (range_start...range_end)
    .filter { |password| Password.new(password).possible? }
    .count
end

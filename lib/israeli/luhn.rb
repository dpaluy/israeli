# frozen_string_literal: true

module Israeli
  # Luhn algorithm (mod 10) implementation for checksum validation.
  #
  # Used by Israeli ID numbers (Mispar Zehut) and potentially business
  # registration numbers. The Israeli variant uses a left-to-right
  # processing order (index 0 = multiplier 1, index 1 = multiplier 2, etc.).
  #
  # @see https://en.wikipedia.org/wiki/Luhn_algorithm
  # @see https://en.wikipedia.org/wiki/Israeli_identity_card
  module Luhn
    # Validates a string of digits using the Luhn algorithm.
    #
    # @param digits [String] A string containing only digits (0-9)
    # @return [Boolean] true if the checksum is valid, false otherwise
    #
    # @example Valid ID
    #   Israeli::Luhn.valid?("123456782") # => true
    #
    # @example Invalid ID
    #   Israeli::Luhn.valid?("123456789") # => false
    def self.valid?(digits)
      return false if digits.nil? || digits.empty?
      return false unless digits.match?(/\A\d+\z/)

      sum = digits.chars.each_with_index.sum do |char, index|
        digit = char.to_i * (index.even? ? 1 : 2)
        digit > 9 ? digit - 9 : digit
      end

      (sum % 10).zero?
    end
  end
end

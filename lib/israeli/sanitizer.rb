# frozen_string_literal: true

module Israeli
  # Input sanitization utilities for Israeli validators.
  #
  # Provides consistent normalization of user input across all validators,
  # handling common formatting variations like spaces, hyphens, and
  # international phone prefixes.
  module Sanitizer
    # Common separator characters to strip from input
    STRIP_CHARS = /[\s\-.+]/

    # Extracts only digit characters from input.
    #
    # Strips common formatting characters (spaces, hyphens, dots) and
    # converts the input to a string. Returns nil for nil input.
    #
    # @param value [String, Integer, nil] The value to sanitize
    # @return [String, nil] String containing only digits, or nil
    #
    # @example Basic usage
    #   Sanitizer.digits_only("123-456-789") # => "123456789"
    #   Sanitizer.digits_only("12 34 56")    # => "123456"
    #   Sanitizer.digits_only(123456)        # => "123456"
    #   Sanitizer.digits_only(nil)           # => nil
    def self.digits_only(value)
      return nil if value.nil?

      value.to_s.gsub(STRIP_CHARS, "")
    end

    # Normalizes phone numbers by stripping international prefixes.
    #
    # Handles common Israeli international dialing formats:
    # - +972 (standard international)
    # - 972 (without plus)
    # - 00972 (international access code)
    #
    # @param value [String, nil] The phone number to normalize
    # @return [String, nil] Normalized domestic phone number, or nil
    #
    # @example International formats
    #   Sanitizer.normalize_phone("+972501234567")   # => "0501234567"
    #   Sanitizer.normalize_phone("972-50-123-4567") # => "0501234567"
    #   Sanitizer.normalize_phone("00972501234567")  # => "0501234567"
    #
    # @example Domestic formats (unchanged)
    #   Sanitizer.normalize_phone("050-123-4567")    # => "0501234567"
    #   Sanitizer.normalize_phone("0501234567")      # => "0501234567"
    def self.normalize_phone(value)
      cleaned = digits_only(value)
      return nil if cleaned.nil?

      # Strip international prefixes and add leading zero
      cleaned.sub(/\A(00972|972)/, "0")
    end
  end
end

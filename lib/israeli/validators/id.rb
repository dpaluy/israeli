# frozen_string_literal: true

module Israeli
  module Validators
    # Validates Israeli ID numbers (Mispar Zehut / Teudat Zehut).
    #
    # Israeli ID numbers are 9-digit numbers where the last digit is a
    # check digit calculated using the Luhn algorithm (mod 10).
    #
    # @example Basic validation
    #   Israeli::Validators::Id.valid?("123456782") # => true
    #   Israeli::Validators::Id.valid?("123456789") # => false
    #
    # @example With formatting
    #   Israeli::Validators::Id.valid?("12345678-2") # => true
    #   Israeli::Validators::Id.valid?("012345678")  # => true (leading zero)
    #
    # @see https://en.wikipedia.org/wiki/Israeli_identity_card
    class Id
      # Validates an Israeli ID number.
      #
      # Accepts formatted input (with hyphens/spaces) and handles leading zeros.
      # IDs shorter than 9 digits are automatically left-padded with zeros.
      #
      # @param value [String, Integer, nil] The ID number to validate
      # @return [Boolean] true if valid, false otherwise
      def self.valid?(value)
        digits = Sanitizer.digits_only(value)
        return false if digits.nil? || digits.empty?

        # Left-pad to 9 digits if shorter (handles IDs like "12345678")
        padded = digits.rjust(9, "0")

        # Must be exactly 9 digits after padding
        return false unless padded.match?(/\A\d{9}\z/)

        Luhn.valid?(padded)
      end

      # Returns the reason why an ID is invalid.
      #
      # @param value [String, Integer, nil] The ID number to check
      # @return [Symbol, nil] Reason code or nil if valid
      #   - :blank - Input is nil or empty
      #   - :wrong_length - Not 9 digits after padding
      #   - :invalid_checksum - Luhn checksum failed
      #
      # @example
      #   Israeli::Validators::Id.invalid_reason("123456789") # => :invalid_checksum
      #   Israeli::Validators::Id.invalid_reason("")          # => :blank
      #   Israeli::Validators::Id.invalid_reason("123456782") # => nil (valid)
      def self.invalid_reason(value)
        digits = Sanitizer.digits_only(value)
        return :blank if digits.nil? || digits.empty?

        padded = digits.rjust(9, "0")
        return :wrong_length unless padded.match?(/\A\d{9}\z/)
        return :invalid_checksum unless Luhn.valid?(padded)

        nil
      end

      # Formats an Israeli ID to standard 9-digit format.
      #
      # @param value [String, Integer, nil] The ID number to format
      # @return [String, nil] 9-digit formatted ID, or nil if invalid
      #
      # @example
      #   Israeli::Validators::Id.format("12345678-2") # => "123456782"
      #   Israeli::Validators::Id.format(12345678)     # => "012345678"
      def self.format(value)
        digits = Sanitizer.digits_only(value)
        return nil if digits.nil? || digits.empty?

        padded = digits.rjust(9, "0")
        return nil unless padded.match?(/\A\d{9}\z/) && Luhn.valid?(padded)

        padded
      end
    end
  end
end

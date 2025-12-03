# frozen_string_literal: true

module Israeli
  module Validators
    # Validates Israeli postal codes (Mikud).
    #
    # Israeli postal codes consist of exactly 7 digits. They are organized
    # geographically from north to south, with the first 2 digits indicating
    # the postal area. Jerusalem postal codes start with 9 despite its
    # central location.
    #
    # @example Basic validation
    #   Israeli::Validators::PostalCode.valid?("2610101") # => true
    #   Israeli::Validators::PostalCode.valid?("26101 01") # => true (with space)
    #
    # @example Regional examples
    #   Israeli::Validators::PostalCode.valid?("1029200") # => true (Metula, north)
    #   Israeli::Validators::PostalCode.valid?("8800000") # => true (Eilat, south)
    #   Israeli::Validators::PostalCode.valid?("9100000") # => true (Jerusalem)
    #
    # @see https://globepostalcodes.com/israel
    class PostalCode
      # Validates an Israeli postal code.
      #
      # @param value [String, nil] The postal code to validate
      # @return [Boolean] true if valid 7-digit format, false otherwise
      def self.valid?(value)
        digits = Sanitizer.digits_only(value)
        return false if digits.nil?

        digits.match?(/\A\d{7}\z/)
      end

      # Formats a postal code to standard representation.
      #
      # @param value [String, nil] The postal code to format
      # @param style [Symbol] :compact (7 digits) or :spaced (5+2 format)
      # @return [String, nil] Formatted postal code, or nil if invalid
      #
      # @example
      #   Israeli::Validators::PostalCode.format("26101 01")             # => "2610101"
      #   Israeli::Validators::PostalCode.format("2610101", style: :spaced) # => "26101 01"
      def self.format(value, style: :compact)
        digits = Sanitizer.digits_only(value)
        return nil unless valid?(digits)

        case style
        when :spaced then "#{digits[0..4]} #{digits[5..6]}"
        else digits
        end
      end
    end
  end
end

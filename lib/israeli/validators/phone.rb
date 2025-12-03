# frozen_string_literal: true

module Israeli
  module Validators
    # Validates Israeli phone numbers.
    #
    # Supports three types of Israeli phone numbers:
    # - Mobile: 10 digits starting with 05X (050, 052, 053, 054, 055, 058)
    # - Landline: 9 digits starting with 0X (02, 03, 04, 08, 09)
    # - VoIP: 10 digits starting with 07X (072-079)
    #
    # Automatically handles international format (+972) conversion.
    #
    # @example Mobile validation
    #   Israeli::Validators::Phone.valid?("0501234567")              # => true
    #   Israeli::Validators::Phone.valid?("+972501234567")           # => true
    #   Israeli::Validators::Phone.valid?("050-123-4567")            # => true
    #
    # @example Landline validation
    #   Israeli::Validators::Phone.valid?("021234567", type: :landline) # => true
    #   Israeli::Validators::Phone.valid?("03-123-4567")                # => true
    #
    # @see https://en.wikipedia.org/wiki/Telephone_numbers_in_Israel
    class Phone
      # Mobile phone pattern: 05X followed by 7 more digits (10 total)
      MOBILE_PATTERN = /\A05\d{8}\z/

      # Landline pattern: 0X followed by 7 digits (9 total)
      # Valid area codes: 02 (Jerusalem), 03 (Tel Aviv), 04 (Haifa), 08 (South), 09 (Sharon)
      LANDLINE_PATTERN = /\A0[2-489]\d{7}\z/

      # VoIP pattern: 07X (X=2-9) followed by 7 digits (10 total)
      VOIP_PATTERN = /\A07[2-9]\d{7}\z/

      # Validates an Israeli phone number.
      #
      # @param value [String, nil] The phone number to validate
      # @param type [Symbol] Type to validate: :mobile, :landline, :voip, or :any
      # @return [Boolean] true if valid, false otherwise
      def self.valid?(value, type: :any)
        normalized = Sanitizer.normalize_phone(value)
        return false if normalized.nil? || normalized.empty?

        case type
        when :mobile then mobile?(normalized)
        when :landline then landline?(normalized)
        when :voip then voip?(normalized)
        when :any then mobile?(normalized) || landline?(normalized) || voip?(normalized)
        else false
        end
      end

      # Checks if the number is a valid mobile number.
      #
      # @param value [String] Normalized phone number
      # @return [Boolean]
      def self.mobile?(value)
        value.match?(MOBILE_PATTERN)
      end

      # Checks if the number is a valid landline number.
      #
      # @param value [String] Normalized phone number
      # @return [Boolean]
      def self.landline?(value)
        value.match?(LANDLINE_PATTERN)
      end

      # Checks if the number is a valid VoIP number.
      #
      # @param value [String] Normalized phone number
      # @return [Boolean]
      def self.voip?(value)
        value.match?(VOIP_PATTERN)
      end

      # Formats a phone number.
      #
      # @param value [String, nil] The phone number to format
      # @param style [Symbol] :dashed, :international, or :compact
      # @return [String, nil] Formatted phone number, or nil if invalid
      #
      # @example
      #   Phone.format("0501234567")                      # => "050-123-4567"
      #   Phone.format("0501234567", style: :international) # => "+972-50-123-4567"
      #   Phone.format("021234567")                       # => "02-123-4567"
      def self.format(value, style: :dashed)
        normalized = Sanitizer.normalize_phone(value)
        return nil unless valid?(normalized)

        case style
        when :dashed
          format_dashed(normalized)
        when :international
          "+972-#{normalized[1..]}"
        else
          normalized
        end
      end

      # @private
      def self.format_dashed(normalized)
        if mobile?(normalized) || voip?(normalized)
          # 10-digit format: XXX-XXX-XXXX
          "#{normalized[0..2]}-#{normalized[3..5]}-#{normalized[6..9]}"
        else
          # 9-digit landline format: XX-XXX-XXXX
          "#{normalized[0..1]}-#{normalized[2..4]}-#{normalized[5..8]}"
        end
      end
      private_class_method :format_dashed
    end
  end
end

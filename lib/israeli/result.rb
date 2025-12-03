# frozen_string_literal: true

module Israeli
  # Result object returned by parse methods.
  #
  # Provides a rich object with validation status, original/normalized values,
  # and formatting methods for a cleaner API than simple booleans.
  #
  # @example Using a parse result
  #   result = Israeli.parse_id("123456782")
  #   result.valid?      # => true
  #   result.formatted   # => "123456782"
  #   result.original    # => "123456782"
  #
  # @example Invalid result
  #   result = Israeli.parse_id("123456789")
  #   result.valid?      # => false
  #   result.invalid?    # => true
  #   result.reason      # => :invalid_checksum
  class Result
    attr_reader :original, :normalized, :reason

    # @param original [String, nil] Original input value
    # @param normalized [String, nil] Normalized/sanitized value
    # @param valid [Boolean] Whether the value is valid
    # @param reason [Symbol, nil] Reason for invalidity
    def initialize(original:, normalized:, valid:, reason: nil)
      @original = original
      @normalized = normalized
      @valid = valid
      @reason = reason
    end

    # @return [Boolean] true if the value is valid
    def valid?
      @valid
    end

    # @return [Boolean] true if the value is invalid
    def invalid?
      !@valid
    end

    # @return [String, nil] The formatted value, or nil if invalid
    def formatted
      return nil unless valid?

      @normalized
    end

    # @return [String] String representation
    def to_s
      formatted || ""
    end

    # @return [String, nil] The normalized value (alias for formatted)
    def value
      formatted
    end
  end

  # Result object for ID validation with formatting.
  class IdResult < Result
    # @return [String, nil] 9-digit formatted ID
    def formatted
      return nil unless valid?

      @normalized
    end
  end

  # Result object for phone validation with type detection and formatting.
  class PhoneResult < Result
    attr_reader :type

    # @param type [Symbol, nil] Detected phone type (:mobile, :landline, :voip)
    def initialize(original:, normalized:, valid:, reason: nil, type: nil)
      super(original: original, normalized: normalized, valid: valid, reason: reason)
      @type = type
    end

    # @return [Boolean] true if this is a mobile phone
    def mobile?
      type == :mobile
    end

    # @return [Boolean] true if this is a landline phone
    def landline?
      type == :landline
    end

    # @return [Boolean] true if this is a VoIP phone
    def voip?
      type == :voip
    end

    # Format the phone number.
    #
    # @param style [Symbol] :dashed, :international, or :compact
    # @return [String, nil] Formatted phone or nil if invalid
    def formatted(style: :dashed)
      return nil unless valid?

      Validators::Phone.format(@normalized, style: style)
    end
  end

  # Result object for postal code validation with formatting.
  class PostalCodeResult < Result
    # Format the postal code.
    #
    # @param style [Symbol] :compact or :spaced
    # @return [String, nil] Formatted postal code or nil if invalid
    def formatted(style: :compact)
      return nil unless valid?

      Validators::PostalCode.format(@normalized, style: style)
    end
  end

  # Result object for bank account validation with format detection.
  class BankAccountResult < Result
    attr_reader :format

    # @param format [Symbol, nil] Detected format (:domestic or :iban)
    def initialize(original:, normalized:, valid:, reason: nil, format: nil)
      super(original: original, normalized: normalized, valid: valid, reason: reason)
      @format = format
    end

    # @return [Boolean] true if this is a domestic account
    def domestic?
      format == :domestic
    end

    # @return [Boolean] true if this is an IBAN
    def iban?
      format == :iban
    end

    # Format the bank account.
    #
    # @param style [Symbol] :domestic, :compact, or :iban
    # @return [String, nil] Formatted bank account or nil if invalid
    def formatted(style: :domestic)
      return nil unless valid?

      Validators::BankAccount.format(@original, style: style)
    end
  end
end

# frozen_string_literal: true

require_relative "israeli/version"
require_relative "israeli/errors"
require_relative "israeli/luhn"
require_relative "israeli/sanitizer"
require_relative "israeli/result"

# Main namespace for the Israeli validators gem.
#
# Provides validation utilities for Israeli identifiers including ID numbers
# (Mispar Zehut), postal codes, phone numbers, and bank accounts.
#
# @example Validate an Israeli ID
#   Israeli.valid_id?("123456782") # => true
#
# @example Validate a phone number
#   Israeli.valid_phone?("0501234567", type: :mobile) # => true
#
# @see Israeli::Validators::Id
# @see Israeli::Validators::Phone
# @see Israeli::Validators::PostalCode
# @see Israeli::Validators::BankAccount
module Israeli # rubocop:disable Metrics/ModuleLength
  class << self # rubocop:disable Metrics/ClassLength
    # Validates an Israeli ID number (Mispar Zehut).
    #
    # @param value [String, Integer] The ID number to validate
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Israeli.valid_id?("123456782")     # => true
    #   Israeli.valid_id?("12345678-2")    # => true (formatted)
    #   Israeli.valid_id?("123456789")     # => false (bad checksum)
    def valid_id?(value)
      Validators::Id.valid?(value)
    end

    # Validates an Israeli postal code (Mikud).
    #
    # @param value [String] The postal code to validate
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Israeli.valid_postal_code?("2610101")   # => true
    #   Israeli.valid_postal_code?("26101 01")  # => true (with space)
    def valid_postal_code?(value)
      Validators::PostalCode.valid?(value)
    end

    # Validates an Israeli phone number.
    #
    # @param value [String] The phone number to validate
    # @param type [Symbol] Type of phone: :mobile, :landline, :voip, or :any
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Israeli.valid_phone?("0501234567")                    # => true
    #   Israeli.valid_phone?("0501234567", type: :mobile)     # => true
    #   Israeli.valid_phone?("+972501234567", type: :mobile)  # => true
    def valid_phone?(value, type: :any)
      Validators::Phone.valid?(value, type: type)
    end

    # Detects the type of phone number.
    #
    # @param value [String] The phone number to check
    # @return [Symbol, nil] :mobile, :landline, :voip, or nil if invalid
    #
    # @example
    #   Israeli.phone_type("0501234567")  # => :mobile
    #   Israeli.phone_type("021234567")   # => :landline
    def phone_type(value)
      Validators::Phone.detect_type(value)
    end

    # Validates an Israeli bank account number.
    #
    # @param value [String] The bank account to validate
    # @param format [Symbol] Format: :domestic, :iban, or :any
    # @return [Boolean] true if valid, false otherwise
    #
    # @example
    #   Israeli.valid_bank_account?("4985622815429")           # => true (domestic)
    #   Israeli.valid_bank_account?("IL620108000000099999999") # => true (IBAN)
    def valid_bank_account?(value, format: :any)
      Validators::BankAccount.valid?(value, format: format)
    end

    # Formats an Israeli ID number to standard 9-digit format.
    #
    # @param value [String, Integer] The ID number to format
    # @return [String, nil] Formatted ID or nil if invalid
    def format_id(value)
      Validators::Id.format(value)
    end

    # Formats an Israeli phone number.
    #
    # @param value [String] The phone number to format
    # @param style [Symbol] Format style: :dashed, :international, or :compact
    # @return [String, nil] Formatted phone or nil if invalid
    def format_phone(value, style: :dashed)
      Validators::Phone.format(value, style: style)
    end

    # Formats an Israeli postal code.
    #
    # @param value [String] The postal code to format
    # @param style [Symbol] Format style: :compact or :spaced
    # @return [String, nil] Formatted postal code or nil if invalid
    def format_postal_code(value, style: :compact)
      Validators::PostalCode.format(value, style: style)
    end

    # Formats an Israeli bank account number.
    #
    # @param value [String] The bank account to format
    # @param style [Symbol] Format style: :domestic, :compact, or :iban
    # @return [String, nil] Formatted bank account or nil if invalid
    def format_bank_account(value, style: :domestic)
      Validators::BankAccount.format(value, style: style)
    end

    # Bang Methods - raise exceptions on invalid input
    # These are useful when you want to fail fast rather than check booleans

    # Validates an Israeli ID number, raising an error if invalid.
    #
    # @param value [String, Integer] The ID number to validate
    # @return [true] Always returns true if valid
    # @raise [Israeli::InvalidIdError] if the ID is invalid
    #
    # @example
    #   Israeli.valid_id!("123456782")  # => true
    #   Israeli.valid_id!("123456789")  # => raises InvalidIdError
    def valid_id!(value)
      return true if valid_id?(value)

      raise InvalidIdError.new("Invalid Israeli ID", reason: Validators::Id.invalid_reason(value))
    end

    # Validates an Israeli phone number, raising an error if invalid.
    #
    # @param value [String] The phone number to validate
    # @param type [Symbol] Type of phone: :mobile, :landline, :voip, or :any
    # @return [true] Always returns true if valid
    # @raise [Israeli::InvalidPhoneError] if the phone is invalid
    def valid_phone!(value, type: :any)
      return true if valid_phone?(value, type: type)

      reason = Validators::Phone.invalid_reason(value, type: type)
      raise InvalidPhoneError.new("Invalid Israeli phone number", reason: reason)
    end

    # Validates an Israeli postal code, raising an error if invalid.
    #
    # @param value [String] The postal code to validate
    # @return [true] Always returns true if valid
    # @raise [Israeli::InvalidPostalCodeError] if the postal code is invalid
    def valid_postal_code!(value)
      return true if valid_postal_code?(value)

      raise InvalidPostalCodeError.new("Invalid Israeli postal code", reason: Validators::PostalCode.invalid_reason(value))
    end

    # Validates an Israeli bank account, raising an error if invalid.
    #
    # @param value [String] The bank account to validate
    # @param format [Symbol] Format: :domestic, :iban, or :any
    # @return [true] Always returns true if valid
    # @raise [Israeli::InvalidBankAccountError] if the bank account is invalid
    def valid_bank_account!(value, format: :any)
      return true if valid_bank_account?(value, format: format)

      reason = Validators::BankAccount.invalid_reason(value, format: format)
      raise InvalidBankAccountError.new("Invalid Israeli bank account", reason: reason)
    end

    # Parse Methods - return rich result objects
    # These provide more detailed information than simple boolean validation

    # Parses an Israeli ID number and returns a result object.
    #
    # @param value [String, Integer] The ID number to parse
    # @return [Israeli::IdResult] Result object with validation status and formatting
    #
    # @example
    #   result = Israeli.parse_id("123456782")
    #   result.valid?     # => true
    #   result.formatted  # => "123456782"
    #
    # @example Invalid ID
    #   result = Israeli.parse_id("123456789")
    #   result.valid?  # => false
    #   result.reason  # => :invalid_checksum
    def parse_id(value)
      digits = Sanitizer.digits_only(value)
      normalized = digits&.rjust(9, "0")
      valid = Validators::Id.valid?(value)
      reason = valid ? nil : Validators::Id.invalid_reason(value)

      IdResult.new(
        original: value,
        normalized: normalized,
        valid: valid,
        reason: reason
      )
    end

    # Parses an Israeli phone number and returns a result object.
    #
    # @param value [String] The phone number to parse
    # @return [Israeli::PhoneResult] Result object with type detection and formatting
    #
    # @example
    #   result = Israeli.parse_phone("0501234567")
    #   result.valid?   # => true
    #   result.type     # => :mobile
    #   result.mobile?  # => true
    #   result.formatted(style: :dashed)  # => "050-123-4567"
    def parse_phone(value)
      normalized = Sanitizer.normalize_phone(value)
      valid = Validators::Phone.valid?(value)
      phone_type = Validators::Phone.detect_type(value)
      reason = valid ? nil : Validators::Phone.invalid_reason(value)

      PhoneResult.new(
        original: value,
        normalized: normalized,
        valid: valid,
        reason: reason,
        type: phone_type
      )
    end

    # Parses an Israeli postal code and returns a result object.
    #
    # @param value [String] The postal code to parse
    # @return [Israeli::PostalCodeResult] Result object with validation and formatting
    #
    # @example
    #   result = Israeli.parse_postal_code("2610101")
    #   result.valid?    # => true
    #   result.formatted # => "2610101"
    #   result.formatted(style: :spaced)  # => "26101 01"
    def parse_postal_code(value)
      digits = Sanitizer.digits_only(value)
      valid = Validators::PostalCode.valid?(value)
      reason = valid ? nil : Validators::PostalCode.invalid_reason(value)

      PostalCodeResult.new(
        original: value,
        normalized: digits,
        valid: valid,
        reason: reason
      )
    end

    # Parses an Israeli bank account and returns a result object.
    #
    # @param value [String] The bank account to parse
    # @return [Israeli::BankAccountResult] Result object with format detection
    #
    # @example
    #   result = Israeli.parse_bank_account("4985622815429")
    #   result.valid?     # => true
    #   result.domestic?  # => true
    #   result.formatted  # => "49-856-22815429"
    def parse_bank_account(value)
      valid = Validators::BankAccount.valid?(value)
      reason = valid ? nil : Validators::BankAccount.invalid_reason(value)
      detected_format = detect_bank_format(value) if valid

      BankAccountResult.new(
        original: value,
        normalized: normalize_bank_value(value, detected_format),
        valid: valid,
        reason: reason,
        format: detected_format
      )
    end

    private

    def detect_bank_format(value)
      digits = Sanitizer.digits_only(value)
      normalized = value.to_s.gsub(/\s/, "").upcase

      return :domestic if Validators::BankAccount.valid_domestic?(digits)
      return :iban if Validators::BankAccount.valid_iban?(normalized)

      nil
    end

    def normalize_bank_value(value, detected_format)
      case detected_format
      when :iban then value.to_s.gsub(/\s/, "").upcase
      else Sanitizer.digits_only(value)
      end
    end
  end
end

# Require validators after module definition to avoid circular dependency
require_relative "israeli/validators/id"
require_relative "israeli/validators/postal_code"
require_relative "israeli/validators/phone"
require_relative "israeli/validators/bank_account"

# Load Rails integration if Rails is available
require_relative "israeli/railtie" if defined?(Rails::Railtie)

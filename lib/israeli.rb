# frozen_string_literal: true

require_relative "israeli/version"
require_relative "israeli/errors"
require_relative "israeli/luhn"
require_relative "israeli/sanitizer"

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
module Israeli
  class << self
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
  end
end

# Require validators after module definition to avoid circular dependency
require_relative "israeli/validators/id"
require_relative "israeli/validators/postal_code"
require_relative "israeli/validators/phone"
require_relative "israeli/validators/bank_account"

# Load Rails integration if Rails is available
require_relative "israeli/railtie" if defined?(Rails::Railtie)

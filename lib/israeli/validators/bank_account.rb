# frozen_string_literal: true

module Israeli
  module Validators
    # Validates Israeli bank account numbers.
    #
    # Supports two formats:
    # - Domestic: 13 digits (2-digit bank + 3-digit branch + 8-digit account)
    # - IBAN: 23 characters (IL + 2 check digits + 19 BBAN digits)
    #
    # @example Domestic validation
    #   Israeli::Validators::BankAccount.valid?("4985622815429")    # => true
    #   Israeli::Validators::BankAccount.valid?("49-856-22815429")  # => true
    #
    # @example IBAN validation
    #   Israeli::Validators::BankAccount.valid?("IL620108000000099999999") # => true
    #
    # @see https://www.ecbs.org/iban/israel-bank-account-number.html
    class BankAccount
      # Domestic format: 2 (bank) + 3 (branch) + 8 (account) = 13 digits
      DOMESTIC_PATTERN = /\A\d{13}\z/

      # IBAN format: IL + 2 check digits + 19 BBAN digits = 23 characters
      IBAN_PATTERN = /\AIL\d{21}\z/

      # Validates an Israeli bank account number.
      #
      # @param value [String, nil] The bank account to validate
      # @param format [Symbol] Format to validate: :domestic, :iban, or :any
      # @return [Boolean] true if valid, false otherwise
      def self.valid?(value, format: :any)
        return false if value.nil?

        case format
        when :domestic
          valid_domestic?(Sanitizer.digits_only(value))
        when :iban
          valid_iban?(normalize_iban(value))
        when :any
          valid_domestic?(Sanitizer.digits_only(value)) ||
            valid_iban?(normalize_iban(value))
        else
          false
        end
      end

      # Validates a domestic Israeli bank account (13 digits).
      #
      # @param digits [String, nil] Digits-only bank account
      # @return [Boolean]
      def self.valid_domestic?(digits)
        return false if digits.nil?

        digits.match?(DOMESTIC_PATTERN)
      end

      # Validates an Israeli IBAN with mod 97 checksum.
      #
      # @param iban [String, nil] Normalized IBAN (uppercase, no spaces)
      # @return [Boolean]
      def self.valid_iban?(iban)
        return false if iban.nil?
        return false unless iban.match?(IBAN_PATTERN)

        # IBAN mod 97 validation
        # 1. Move first 4 chars to end
        # 2. Convert letters to numbers (A=10, B=11, ..., Z=35)
        # 3. Calculate mod 97, must equal 1
        rearranged = iban[4..] + iban[0..3]
        numeric = rearranged.gsub(/[A-Z]/) { |c| (c.ord - 55).to_s }
        numeric.to_i % 97 == 1
      end

      # Formats a bank account to a specified style.
      #
      # @param value [String, nil] The bank account to format
      # @param style [Symbol] :domestic (XX-XXX-XXXXXXXX) or :iban
      # @return [String, nil] Formatted bank account, or nil if invalid
      #
      # @example
      #   BankAccount.format("4985622815429")              # => "49-856-22815429"
      #   BankAccount.format("4985622815429", style: :compact) # => "4985622815429"
      def self.format(value, style: :domestic)
        digits = Sanitizer.digits_only(value)

        if valid_domestic?(digits)
          case style
          when :domestic
            "#{digits[0..1]}-#{digits[2..4]}-#{digits[5..12]}"
          else
            digits
          end
        elsif valid_iban?(normalize_iban(value))
          normalize_iban(value)
        end
      end

      # @private
      def self.normalize_iban(value)
        value.to_s.gsub(/\s/, "").upcase
      end
      private_class_method :normalize_iban
    end
  end
end

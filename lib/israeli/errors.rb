# frozen_string_literal: true

module Israeli
  # Base error class for all Israeli validation errors.
  #
  # All validation-related exceptions inherit from this class.
  #
  # @example Handling errors
  #   begin
  #     Israeli.valid_id!("invalid")
  #   rescue Israeli::Error => e
  #     puts "Validation failed: #{e.message}"
  #   end
  class Error < StandardError; end

  # Raised when input format is invalid for the requested validation type.
  #
  # @example
  #   Israeli.valid_id!("123456789")
  #   # => Israeli::InvalidFormatError: Invalid Israeli ID
  class InvalidFormatError < Error
    attr_reader :reason

    # @param message [String] Human-readable error message
    # @param reason [Symbol, nil] Machine-readable reason code
    def initialize(message = nil, reason: nil)
      @reason = reason
      super(message)
    end
  end

  # Raised when an Israeli ID number is invalid.
  class InvalidIdError < InvalidFormatError; end

  # Raised when an Israeli phone number is invalid.
  class InvalidPhoneError < InvalidFormatError; end

  # Raised when an Israeli postal code is invalid.
  class InvalidPostalCodeError < InvalidFormatError; end

  # Raised when an Israeli bank account number is invalid.
  class InvalidBankAccountError < InvalidFormatError; end
end

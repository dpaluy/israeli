# frozen_string_literal: true

module Israeli
  # Base error class for all Israeli validation errors.
  #
  # All validation-related exceptions inherit from this class.
  #
  # @example Handling errors
  #   begin
  #     Israeli.format_id!("invalid")
  #   rescue Israeli::Error => e
  #     puts "Validation failed: #{e.message}"
  #   end
  class Error < StandardError; end

  # Raised when input format is invalid for the requested validation type.
  #
  # @example
  #   Israeli.format_id!("abc")
  #   # => Israeli::InvalidFormatError: ID must contain only digits
  class InvalidFormatError < Error; end
end

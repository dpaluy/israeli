# frozen_string_literal: true

require "active_model"

# Validates that an attribute is a valid Israeli postal code (Mikud).
#
# @example Basic usage
#   class Address < ApplicationRecord
#     validates :postal_code, israeli_postal_code: true
#   end
#
# @example With options
#   class Address < ApplicationRecord
#     validates :postal_code, israeli_postal_code: { allow_blank: true }
#   end
class IsraeliPostalCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value.nil? && options[:allow_nil]

    return if Israeli::Validators::PostalCode.valid?(value)

    record.errors.add(
      attribute,
      options[:message] || :invalid
    )
  end
end

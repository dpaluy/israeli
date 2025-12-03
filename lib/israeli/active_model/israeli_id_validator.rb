# frozen_string_literal: true

require "active_model"

# Validates that an attribute is a valid Israeli ID number (Mispar Zehut).
#
# @example Basic usage
#   class Person < ApplicationRecord
#     validates :id_number, israeli_id: true
#   end
#
# @example With options
#   class Person < ApplicationRecord
#     validates :id_number, israeli_id: { allow_blank: true, message: "is not a valid Israeli ID" }
#   end
class IsraeliIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value.nil? && options[:allow_nil]

    return if Israeli::Validators::Id.valid?(value)

    record.errors.add(
      attribute,
      options[:message] || :invalid
    )
  end
end

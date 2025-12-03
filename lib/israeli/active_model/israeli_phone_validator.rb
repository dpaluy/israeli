# frozen_string_literal: true

require "active_model"

# Validates that an attribute is a valid Israeli phone number.
#
# @example Basic usage (accepts mobile, landline, or VoIP)
#   class Contact < ApplicationRecord
#     validates :phone, israeli_phone: true
#   end
#
# @example Mobile only
#   class Contact < ApplicationRecord
#     validates :mobile_phone, israeli_phone: { type: :mobile }
#   end
#
# @example Landline only
#   class Contact < ApplicationRecord
#     validates :office_phone, israeli_phone: { type: :landline }
#   end
#
# @example VoIP only
#   class Contact < ApplicationRecord
#     validates :voip_number, israeli_phone: { type: :voip }
#   end
class IsraeliPhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value.nil? && options[:allow_nil]

    phone_type = options[:type] || :any
    return if Israeli::Validators::Phone.valid?(value, type: phone_type)

    reason = Israeli::Validators::Phone.invalid_reason(value, type: phone_type)
    detected_type = Israeli::Validators::Phone.detect_type(value)
    record.errors.add(
      attribute,
      options[:message] || :invalid,
      reason: reason,
      expected_type: phone_type,
      detected_type: detected_type
    )
  end
end

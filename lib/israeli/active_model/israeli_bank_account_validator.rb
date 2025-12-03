# frozen_string_literal: true

require "active_model"

# Validates that an attribute is a valid Israeli bank account number.
#
# @example Basic usage (accepts domestic or IBAN)
#   class BankAccount < ApplicationRecord
#     validates :account_number, israeli_bank_account: true
#   end
#
# @example Domestic format only
#   class BankAccount < ApplicationRecord
#     validates :domestic_account, israeli_bank_account: { format: :domestic }
#   end
#
# @example IBAN format only
#   class BankAccount < ApplicationRecord
#     validates :iban, israeli_bank_account: { format: :iban }
#   end
class IsraeliBankAccountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? && options[:allow_blank]
    return if value.nil? && options[:allow_nil]

    account_format = options[:format] || :any
    return if Israeli::Validators::BankAccount.valid?(value, format: account_format)

    record.errors.add(
      attribute,
      options[:message] || :invalid
    )
  end
end

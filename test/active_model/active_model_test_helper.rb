# frozen_string_literal: true

require "test_helper"
require "active_model"

# Require all ActiveModel validators
require "israeli/active_model/israeli_id_validator"
require "israeli/active_model/israeli_postal_code_validator"
require "israeli/active_model/israeli_phone_validator"
require "israeli/active_model/israeli_bank_account_validator"

# Base test model for validation testing
class TestModelBase
  include ActiveModel::Validations

  attr_accessor :id_number, :postal_code, :phone, :bank_account

  def initialize(attributes = {})
    attributes.each do |key, value|
      public_send(:"#{key}=", value)
    end
  end
end

# Pre-defined test models with specific validations
class IdTestModel < TestModelBase
  validates :id_number, israeli_id: true
end

class IdTestModelAllowNil < TestModelBase
  validates :id_number, israeli_id: { allow_nil: true }
end

class IdTestModelAllowBlank < TestModelBase
  validates :id_number, israeli_id: { allow_blank: true }
end

class IdTestModelCustomMessage < TestModelBase
  validates :id_number, israeli_id: { message: "is not a valid Mispar Zehut" }
end

class PhoneTestModel < TestModelBase
  validates :phone, israeli_phone: true
end

class PhoneTestModelMobile < TestModelBase
  validates :phone, israeli_phone: { type: :mobile }
end

class PhoneTestModelLandline < TestModelBase
  validates :phone, israeli_phone: { type: :landline }
end

class PhoneTestModelAllowBlank < TestModelBase
  validates :phone, israeli_phone: { allow_blank: true }
end

class PhoneTestModelCustomMessage < TestModelBase
  validates :phone, israeli_phone: { message: "must be a valid Israeli phone" }
end

class PostalCodeTestModel < TestModelBase
  validates :postal_code, israeli_postal_code: true
end

class PostalCodeTestModelAllowBlank < TestModelBase
  validates :postal_code, israeli_postal_code: { allow_blank: true }
end

class PostalCodeTestModelCustomMessage < TestModelBase
  validates :postal_code, israeli_postal_code: { message: "must be a valid Israeli postal code" }
end

class BankAccountTestModel < TestModelBase
  validates :bank_account, israeli_bank_account: true
end

class BankAccountTestModelDomestic < TestModelBase
  validates :bank_account, israeli_bank_account: { format: :domestic }
end

class BankAccountTestModelIban < TestModelBase
  validates :bank_account, israeli_bank_account: { format: :iban }
end

class BankAccountTestModelAllowBlank < TestModelBase
  validates :bank_account, israeli_bank_account: { allow_blank: true }
end

class BankAccountTestModelCustomMessage < TestModelBase
  validates :bank_account, israeli_bank_account: { message: "must be a valid Israeli bank account" }
end

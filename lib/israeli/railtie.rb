# frozen_string_literal: true

module Israeli
  # Rails integration for Israeli validators.
  #
  # Automatically loads ActiveModel validators when used in a Rails application.
  # The validators are loaded via ActiveSupport's lazy load hooks to ensure
  # proper initialization timing.
  #
  # @example Usage in a Rails model
  #   class Person < ApplicationRecord
  #     validates :id_number, israeli_id: true
  #     validates :phone, israeli_phone: { type: :mobile }
  #     validates :postal_code, israeli_postal_code: { allow_blank: true }
  #     validates :bank_account, israeli_bank_account: { format: :iban }
  #   end
  class Railtie < Rails::Railtie
    initializer "israeli.active_model" do
      ActiveSupport.on_load(:active_model) do
        require "israeli/active_model/israeli_id_validator"
        require "israeli/active_model/israeli_postal_code_validator"
        require "israeli/active_model/israeli_phone_validator"
        require "israeli/active_model/israeli_bank_account_validator"
      end
    end
  end
end

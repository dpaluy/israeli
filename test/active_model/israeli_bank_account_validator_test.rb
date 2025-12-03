# frozen_string_literal: true

require_relative "active_model_test_helper"

class IsraeliBankAccountValidatorTest < Minitest::Test
  def test_valid_domestic
    model = BankAccountTestModel.new(bank_account: "4985622815429")
    assert model.valid?
  end

  def test_valid_iban
    model = BankAccountTestModel.new(bank_account: "IL620108000000099999999")
    assert model.valid?
  end

  def test_invalid_bank_account
    model = BankAccountTestModel.new(bank_account: "123456")
    refute model.valid?
  end

  def test_domestic_format_accepts_domestic
    model = BankAccountTestModelDomestic.new(bank_account: "4985622815429")
    assert model.valid?
  end

  def test_domestic_format_rejects_iban
    model = BankAccountTestModelDomestic.new(bank_account: "IL620108000000099999999")
    refute model.valid?
  end

  def test_iban_format_accepts_iban
    model = BankAccountTestModelIban.new(bank_account: "IL620108000000099999999")
    assert model.valid?
  end

  def test_iban_format_rejects_domestic
    model = BankAccountTestModelIban.new(bank_account: "4985622815429")
    refute model.valid?
  end

  def test_allow_blank
    model = BankAccountTestModelAllowBlank.new(bank_account: "")
    assert model.valid?
  end

  def test_custom_message
    model = BankAccountTestModelCustomMessage.new(bank_account: "invalid")
    refute model.valid?
    assert_includes model.errors[:bank_account], "must be a valid Israeli bank account"
  end
end

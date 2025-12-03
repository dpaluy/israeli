# frozen_string_literal: true

require "test_helper"

class BankAccountValidatorTest < Minitest::Test
  # Valid domestic tests
  def test_valid_domestic_13_digits
    assert Israeli::Validators::BankAccount.valid?("4985622815429", format: :domestic)
  end

  def test_valid_domestic_with_hyphens
    assert Israeli::Validators::BankAccount.valid?("49-856-22815429", format: :domestic)
  end

  def test_valid_domestic_with_spaces
    assert Israeli::Validators::BankAccount.valid?("49 856 22815429", format: :domestic)
  end

  # Valid IBAN tests
  def test_valid_iban
    assert Israeli::Validators::BankAccount.valid?("IL620108000000099999999", format: :iban)
  end

  def test_valid_iban_with_spaces
    assert Israeli::Validators::BankAccount.valid?("IL62 0108 0000 0009 9999 999", format: :iban)
  end

  def test_valid_iban_lowercase
    assert Israeli::Validators::BankAccount.valid?("il620108000000099999999", format: :iban)
  end

  # Invalid domestic tests
  def test_invalid_domestic_12_digits
    refute Israeli::Validators::BankAccount.valid?("498562281542", format: :domestic)
  end

  def test_invalid_domestic_14_digits
    refute Israeli::Validators::BankAccount.valid?("49856228154290", format: :domestic)
  end

  # Invalid IBAN tests
  def test_invalid_iban_bad_checksum
    # IL63 should fail mod 97 check
    refute Israeli::Validators::BankAccount.valid?("IL630108000000099999999", format: :iban)
  end

  def test_invalid_iban_wrong_country
    refute Israeli::Validators::BankAccount.valid?("DE620108000000099999999", format: :iban)
  end

  def test_invalid_iban_too_short
    refute Israeli::Validators::BankAccount.valid?("IL6201080000000999999", format: :iban)
  end

  def test_invalid_iban_too_long
    refute Israeli::Validators::BankAccount.valid?("IL62010800000009999999999", format: :iban)
  end

  # Nil and empty tests
  def test_invalid_nil
    refute Israeli::Validators::BankAccount.valid?(nil)
  end

  def test_invalid_empty
    refute Israeli::Validators::BankAccount.valid?("")
  end

  # Format :any tests
  def test_any_accepts_domestic
    assert Israeli::Validators::BankAccount.valid?("4985622815429", format: :any)
  end

  def test_any_accepts_iban
    assert Israeli::Validators::BankAccount.valid?("IL620108000000099999999", format: :any)
  end

  def test_any_is_default
    assert Israeli::Validators::BankAccount.valid?("4985622815429")
    assert Israeli::Validators::BankAccount.valid?("IL620108000000099999999")
  end

  # Format output tests
  def test_format_domestic_style
    assert_equal "49-856-22815429", Israeli::Validators::BankAccount.format("4985622815429", style: :domestic)
  end

  def test_format_compact_style
    assert_equal "4985622815429", Israeli::Validators::BankAccount.format("49-856-22815429", style: :compact)
  end

  def test_format_iban_normalized
    assert_equal "IL620108000000099999999", Israeli::Validators::BankAccount.format("IL62 0108 0000 0009 9999 999")
  end

  # Facade method tests
  def test_facade_valid_bank_account
    assert Israeli.valid_bank_account?("4985622815429")
    assert Israeli.valid_bank_account?("IL620108000000099999999")
    refute Israeli.valid_bank_account?("123456")
  end

  def test_facade_valid_bank_account_with_format
    assert Israeli.valid_bank_account?("4985622815429", format: :domestic)
    refute Israeli.valid_bank_account?("4985622815429", format: :iban)
  end
end

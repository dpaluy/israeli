# frozen_string_literal: true

require "test_helper"

class IsraeliTest < Minitest::Test
  # ========================================
  # Format Methods (format_postal_code, format_bank_account)
  # ========================================

  def test_format_postal_code_compact
    assert_equal "2610101", Israeli.format_postal_code("26101 01")
    assert_equal "2610101", Israeli.format_postal_code("2610101")
  end

  def test_format_postal_code_spaced
    assert_equal "26101 01", Israeli.format_postal_code("2610101", style: :spaced)
  end

  def test_format_postal_code_invalid
    assert_nil Israeli.format_postal_code("123")
    assert_nil Israeli.format_postal_code("")
  end

  def test_format_bank_account_domestic
    assert_equal "49-856-22815429", Israeli.format_bank_account("4985622815429")
  end

  def test_format_bank_account_compact
    assert_equal "4985622815429", Israeli.format_bank_account("4985622815429", style: :compact)
  end

  def test_format_bank_account_iban
    assert_equal "IL620108000000099999999", Israeli.format_bank_account("IL62 0108 0000 0009 9999 999")
  end

  def test_format_bank_account_invalid
    assert_nil Israeli.format_bank_account("123")
  end

  # ========================================
  # Phone Type Detection
  # ========================================

  def test_phone_type_mobile
    assert_equal :mobile, Israeli.phone_type("0501234567")
    assert_equal :mobile, Israeli.phone_type("+972501234567")
  end

  def test_phone_type_landline
    assert_equal :landline, Israeli.phone_type("021234567")
  end

  def test_phone_type_voip
    assert_equal :voip, Israeli.phone_type("0721234567")
  end

  def test_phone_type_invalid
    assert_nil Israeli.phone_type("invalid")
    assert_nil Israeli.phone_type("")
  end

  def test_detect_type_on_validator
    assert_equal :mobile, Israeli::Validators::Phone.detect_type("0501234567")
    assert_equal :landline, Israeli::Validators::Phone.detect_type("031234567")
    assert_equal :voip, Israeli::Validators::Phone.detect_type("0751234567")
  end

  # ========================================
  # Bang Methods
  # ========================================

  def test_valid_id_bang_with_valid_id
    assert Israeli.valid_id!("123456782")
  end

  def test_valid_id_bang_with_invalid_id
    error = assert_raises(Israeli::InvalidIdError) do
      Israeli.valid_id!("123456789")
    end
    assert_equal :invalid_checksum, error.reason
  end

  def test_valid_phone_bang_with_valid_phone
    assert Israeli.valid_phone!("0501234567")
  end

  def test_valid_phone_bang_with_invalid_phone
    error = assert_raises(Israeli::InvalidPhoneError) do
      Israeli.valid_phone!("invalid")
    end
    assert_equal :invalid_format, error.reason
  end

  def test_valid_phone_bang_with_wrong_type
    error = assert_raises(Israeli::InvalidPhoneError) do
      Israeli.valid_phone!("021234567", type: :mobile)
    end
    assert_equal :wrong_type, error.reason
  end

  def test_valid_postal_code_bang_with_valid_code
    assert Israeli.valid_postal_code!("2610101")
  end

  def test_valid_postal_code_bang_with_invalid_code
    error = assert_raises(Israeli::InvalidPostalCodeError) do
      Israeli.valid_postal_code!("123")
    end
    assert_equal :wrong_length, error.reason
  end

  def test_valid_bank_account_bang_with_valid_account
    assert Israeli.valid_bank_account!("4985622815429")
  end

  def test_valid_bank_account_bang_with_invalid_account
    error = assert_raises(Israeli::InvalidBankAccountError) do
      Israeli.valid_bank_account!("123")
    end
    assert_equal :invalid_format, error.reason
  end

  # ========================================
  # Invalid Reason Methods
  # ========================================

  def test_id_invalid_reason_valid
    assert_nil Israeli::Validators::Id.invalid_reason("123456782")
  end

  def test_id_invalid_reason_blank
    assert_equal :blank, Israeli::Validators::Id.invalid_reason("")
    assert_equal :blank, Israeli::Validators::Id.invalid_reason(nil)
  end

  def test_id_invalid_reason_checksum
    assert_equal :invalid_checksum, Israeli::Validators::Id.invalid_reason("123456789")
  end

  def test_phone_invalid_reason_blank
    assert_equal :blank, Israeli::Validators::Phone.invalid_reason("")
  end

  def test_phone_invalid_reason_invalid_format
    assert_equal :invalid_format, Israeli::Validators::Phone.invalid_reason("abc")
  end

  def test_phone_invalid_reason_wrong_type
    assert_equal :wrong_type, Israeli::Validators::Phone.invalid_reason("021234567", type: :mobile)
  end

  def test_postal_code_invalid_reason_blank
    assert_equal :blank, Israeli::Validators::PostalCode.invalid_reason("")
  end

  def test_postal_code_invalid_reason_wrong_length
    assert_equal :wrong_length, Israeli::Validators::PostalCode.invalid_reason("123")
  end

  def test_bank_account_invalid_reason_blank
    assert_equal :blank, Israeli::Validators::BankAccount.invalid_reason("")
  end

  def test_bank_account_invalid_reason_wrong_length_domestic
    assert_equal :wrong_length, Israeli::Validators::BankAccount.invalid_reason("123", format: :domestic)
  end

  def test_bank_account_invalid_reason_invalid_checksum_iban
    iban = "IL990108000000099999999"
    assert_equal :invalid_checksum, Israeli::Validators::BankAccount.invalid_reason(iban, format: :iban)
  end

  # ========================================
  # Parse Methods
  # ========================================

  def test_parse_id_valid
    result = Israeli.parse_id("123456782")
    assert result.valid?
    refute result.invalid?
    assert_equal "123456782", result.formatted
    assert_equal "123456782", result.original
    assert_nil result.reason
  end

  def test_parse_id_invalid
    result = Israeli.parse_id("123456789")
    refute result.valid?
    assert result.invalid?
    assert_nil result.formatted
    assert_equal :invalid_checksum, result.reason
  end

  def test_parse_id_with_padding
    # 10000008 pads to 010000008 which has a valid Luhn checksum
    result = Israeli.parse_id("10000008")
    assert result.valid?
    assert_equal "010000008", result.formatted
  end

  def test_parse_phone_valid_mobile
    result = Israeli.parse_phone("0501234567")
    assert result.valid?
    assert_equal :mobile, result.type
    assert result.mobile?
    refute result.landline?
    refute result.voip?
    assert_equal "050-123-4567", result.formatted
    assert_equal "+972-501234567", result.formatted(style: :international)
  end

  def test_parse_phone_valid_landline
    result = Israeli.parse_phone("021234567")
    assert result.valid?
    assert_equal :landline, result.type
    assert result.landline?
    refute result.mobile?
  end

  def test_parse_phone_valid_voip
    result = Israeli.parse_phone("0721234567")
    assert result.valid?
    assert_equal :voip, result.type
    assert result.voip?
  end

  def test_parse_phone_invalid
    result = Israeli.parse_phone("invalid")
    refute result.valid?
    assert_nil result.type
    assert_equal :invalid_format, result.reason
    assert_nil result.formatted
  end

  def test_parse_postal_code_valid
    result = Israeli.parse_postal_code("2610101")
    assert result.valid?
    assert_equal "2610101", result.formatted
    assert_equal "26101 01", result.formatted(style: :spaced)
  end

  def test_parse_postal_code_invalid
    result = Israeli.parse_postal_code("123")
    refute result.valid?
    assert_equal :wrong_length, result.reason
    assert_nil result.formatted
  end

  def test_parse_bank_account_domestic
    result = Israeli.parse_bank_account("4985622815429")
    assert result.valid?
    assert result.domestic?
    refute result.iban?
    assert_equal :domestic, result.format
    assert_equal "49-856-22815429", result.formatted
  end

  def test_parse_bank_account_iban
    result = Israeli.parse_bank_account("IL620108000000099999999")
    assert result.valid?
    assert result.iban?
    refute result.domestic?
    assert_equal :iban, result.format
  end

  def test_parse_bank_account_invalid
    result = Israeli.parse_bank_account("123")
    refute result.valid?
    assert_equal :invalid_format, result.reason
  end

  # ========================================
  # Error Classes
  # ========================================

  def test_error_hierarchy
    assert Israeli::Error < StandardError
    assert Israeli::InvalidFormatError < Israeli::Error
    assert Israeli::InvalidIdError < Israeli::InvalidFormatError
    assert Israeli::InvalidPhoneError < Israeli::InvalidFormatError
    assert Israeli::InvalidPostalCodeError < Israeli::InvalidFormatError
    assert Israeli::InvalidBankAccountError < Israeli::InvalidFormatError
  end

  def test_error_reason_accessor
    error = Israeli::InvalidFormatError.new("test", reason: :test_reason)
    assert_equal :test_reason, error.reason
    assert_equal "test", error.message
  end
end

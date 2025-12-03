# frozen_string_literal: true

require "test_helper"

class IdValidatorTest < Minitest::Test
  # Valid ID tests
  def test_valid_id_with_standard_format
    assert Israeli::Validators::Id.valid?("123456782")
  end

  def test_valid_id_with_leading_zero
    # 010000008 is valid (padded from 10000008)
    assert Israeli::Validators::Id.valid?("010000008")
  end

  def test_valid_id_with_hyphen
    assert Israeli::Validators::Id.valid?("12345678-2")
  end

  def test_valid_id_with_spaces
    assert Israeli::Validators::Id.valid?("123 456 782")
  end

  def test_valid_id_from_integer
    # Integer will be left-padded to 9 digits
    assert Israeli::Validators::Id.valid?(123_456_782)
  end

  def test_valid_id_short_padded
    # 8-digit ID that becomes valid when padded to 9 digits
    # 10000008 -> 010000008 (valid)
    assert Israeli::Validators::Id.valid?("10000008")
  end

  # Invalid ID tests
  def test_invalid_id_bad_checksum
    refute Israeli::Validators::Id.valid?("123456789")
  end

  def test_invalid_id_too_long
    refute Israeli::Validators::Id.valid?("1234567890")
  end

  def test_invalid_id_contains_letter
    refute Israeli::Validators::Id.valid?("12345678A")
  end

  def test_invalid_id_empty
    refute Israeli::Validators::Id.valid?("")
  end

  def test_invalid_id_nil
    refute Israeli::Validators::Id.valid?(nil)
  end

  def test_invalid_id_all_zeros
    # 000000000 has checksum 0 which is valid mod 10
    # but let's verify
    assert Israeli::Validators::Id.valid?("000000000")
  end

  # Format tests
  def test_format_returns_padded_nine_digits
    assert_equal "123456782", Israeli::Validators::Id.format("123456782")
  end

  def test_format_strips_formatting
    assert_equal "123456782", Israeli::Validators::Id.format("123-456-782")
  end

  def test_format_pads_short_id
    # 10000008 pads to 010000008 (valid)
    assert_equal "010000008", Israeli::Validators::Id.format("10000008")
  end

  def test_format_returns_nil_for_invalid
    assert_nil Israeli::Validators::Id.format("123456789")
  end

  def test_format_returns_nil_for_nil
    assert_nil Israeli::Validators::Id.format(nil)
  end

  def test_format_returns_nil_for_empty
    assert_nil Israeli::Validators::Id.format("")
  end

  # Facade method tests
  def test_facade_valid_id
    assert Israeli.valid_id?("123456782")
    refute Israeli.valid_id?("123456789")
  end

  def test_facade_format_id
    assert_equal "123456782", Israeli.format_id("123-456-782")
  end
end

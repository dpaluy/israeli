# frozen_string_literal: true

require "test_helper"

class SanitizerTest < Minitest::Test
  # digits_only tests
  def test_digits_only_strips_hyphens
    assert_equal "123456789", Israeli::Sanitizer.digits_only("123-456-789")
  end

  def test_digits_only_strips_spaces
    assert_equal "123456789", Israeli::Sanitizer.digits_only("123 456 789")
  end

  def test_digits_only_strips_dots
    assert_equal "123456789", Israeli::Sanitizer.digits_only("123.456.789")
  end

  def test_digits_only_handles_integers
    assert_equal "123456789", Israeli::Sanitizer.digits_only(123_456_789)
  end

  def test_digits_only_returns_nil_for_nil
    assert_nil Israeli::Sanitizer.digits_only(nil)
  end

  def test_digits_only_preserves_leading_zeros
    assert_equal "012345678", Israeli::Sanitizer.digits_only("012345678")
  end

  # normalize_phone tests
  def test_normalize_phone_strips_plus_972
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("+972501234567")
  end

  def test_normalize_phone_strips_972
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("972501234567")
  end

  def test_normalize_phone_strips_00972
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("00972501234567")
  end

  def test_normalize_phone_handles_formatted_international
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("+972-50-123-4567")
  end

  def test_normalize_phone_leaves_domestic_unchanged
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("0501234567")
  end

  def test_normalize_phone_strips_dashes_from_domestic
    assert_equal "0501234567", Israeli::Sanitizer.normalize_phone("050-123-4567")
  end

  def test_normalize_phone_returns_nil_for_nil
    assert_nil Israeli::Sanitizer.normalize_phone(nil)
  end
end

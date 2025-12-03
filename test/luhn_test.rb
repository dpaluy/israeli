# frozen_string_literal: true

require "test_helper"

class LuhnTest < Minitest::Test
  def test_valid_checksum
    # Known valid Israeli IDs
    assert Israeli::Luhn.valid?("123456782")
    assert Israeli::Luhn.valid?("000000018")
    assert Israeli::Luhn.valid?("000000000")
  end

  def test_invalid_checksum
    refute Israeli::Luhn.valid?("123456789")
    refute Israeli::Luhn.valid?("000000001")
    refute Israeli::Luhn.valid?("111111111")
  end

  def test_nil_input
    refute Israeli::Luhn.valid?(nil)
  end

  def test_empty_input
    refute Israeli::Luhn.valid?("")
  end

  def test_non_digit_input
    refute Israeli::Luhn.valid?("12345678A")
    refute Israeli::Luhn.valid?("abcdefghi")
  end

  def test_single_digit
    # Single digit should work (0 is valid mod 10)
    assert Israeli::Luhn.valid?("0")
    refute Israeli::Luhn.valid?("1")
  end
end

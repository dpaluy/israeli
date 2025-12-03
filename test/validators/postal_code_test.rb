# frozen_string_literal: true

require "test_helper"

class PostalCodeValidatorTest < Minitest::Test
  # Valid postal code tests
  def test_valid_seven_digits
    assert Israeli::Validators::PostalCode.valid?("2610101")
  end

  def test_valid_with_space
    assert Israeli::Validators::PostalCode.valid?("26101 01")
  end

  def test_valid_metula_north
    assert Israeli::Validators::PostalCode.valid?("1029200")
  end

  def test_valid_eilat_south
    assert Israeli::Validators::PostalCode.valid?("8800000")
  end

  def test_valid_jerusalem
    assert Israeli::Validators::PostalCode.valid?("9100000")
  end

  def test_valid_all_zeros
    # Format validation only, no range check
    assert Israeli::Validators::PostalCode.valid?("0000000")
  end

  # Invalid postal code tests
  def test_invalid_six_digits
    refute Israeli::Validators::PostalCode.valid?("261010")
  end

  def test_invalid_eight_digits
    refute Israeli::Validators::PostalCode.valid?("26101010")
  end

  def test_invalid_letters
    refute Israeli::Validators::PostalCode.valid?("ABCDEFG")
  end

  def test_invalid_mixed
    refute Israeli::Validators::PostalCode.valid?("26101AB")
  end

  def test_invalid_nil
    refute Israeli::Validators::PostalCode.valid?(nil)
  end

  def test_invalid_empty
    refute Israeli::Validators::PostalCode.valid?("")
  end

  # Format tests
  def test_format_compact
    assert_equal "2610101", Israeli::Validators::PostalCode.format("26101 01")
  end

  def test_format_spaced
    assert_equal "26101 01", Israeli::Validators::PostalCode.format("2610101", style: :spaced)
  end

  def test_format_returns_nil_for_invalid
    assert_nil Israeli::Validators::PostalCode.format("123456")
  end

  def test_format_returns_nil_for_nil
    assert_nil Israeli::Validators::PostalCode.format(nil)
  end

  # Facade method tests
  def test_facade_valid_postal_code
    assert Israeli.valid_postal_code?("2610101")
    refute Israeli.valid_postal_code?("123456")
  end
end

# frozen_string_literal: true

require "test_helper"

class PhoneValidatorTest < Minitest::Test
  # Valid mobile tests
  def test_valid_mobile_050
    assert Israeli::Validators::Phone.valid?("0501234567", type: :mobile)
  end

  def test_valid_mobile_052
    assert Israeli::Validators::Phone.valid?("0521234567", type: :mobile)
  end

  def test_valid_mobile_053
    assert Israeli::Validators::Phone.valid?("0531234567", type: :mobile)
  end

  def test_valid_mobile_054
    assert Israeli::Validators::Phone.valid?("0541234567", type: :mobile)
  end

  def test_valid_mobile_055
    assert Israeli::Validators::Phone.valid?("0551234567", type: :mobile)
  end

  def test_valid_mobile_058
    assert Israeli::Validators::Phone.valid?("0581234567", type: :mobile)
  end

  def test_valid_mobile_with_dashes
    assert Israeli::Validators::Phone.valid?("050-123-4567", type: :mobile)
  end

  def test_valid_mobile_international_plus
    assert Israeli::Validators::Phone.valid?("+972501234567", type: :mobile)
  end

  def test_valid_mobile_international_972
    assert Israeli::Validators::Phone.valid?("972501234567", type: :mobile)
  end

  def test_valid_mobile_international_00972
    assert Israeli::Validators::Phone.valid?("00972501234567", type: :mobile)
  end

  # Valid landline tests
  def test_valid_landline_jerusalem_02
    assert Israeli::Validators::Phone.valid?("021234567", type: :landline)
  end

  def test_valid_landline_tel_aviv_03
    assert Israeli::Validators::Phone.valid?("031234567", type: :landline)
  end

  def test_valid_landline_haifa_04
    assert Israeli::Validators::Phone.valid?("041234567", type: :landline)
  end

  def test_valid_landline_south_08
    assert Israeli::Validators::Phone.valid?("081234567", type: :landline)
  end

  def test_valid_landline_sharon_09
    assert Israeli::Validators::Phone.valid?("091234567", type: :landline)
  end

  def test_valid_landline_with_dashes
    assert Israeli::Validators::Phone.valid?("02-123-4567", type: :landline)
  end

  # Valid VoIP tests
  def test_valid_voip_072
    assert Israeli::Validators::Phone.valid?("0721234567", type: :voip)
  end

  def test_valid_voip_077
    assert Israeli::Validators::Phone.valid?("0771234567", type: :voip)
  end

  # Invalid tests
  def test_invalid_mobile_prefix_060
    refute Israeli::Validators::Phone.valid?("0601234567", type: :mobile)
  end

  def test_invalid_landline_prefix_01
    refute Israeli::Validators::Phone.valid?("011234567", type: :landline)
  end

  def test_invalid_mobile_too_short
    refute Israeli::Validators::Phone.valid?("05012345", type: :mobile)
  end

  def test_invalid_mobile_too_long
    refute Israeli::Validators::Phone.valid?("05012345678", type: :mobile)
  end

  def test_invalid_nil
    refute Israeli::Validators::Phone.valid?(nil)
  end

  def test_invalid_empty
    refute Israeli::Validators::Phone.valid?("")
  end

  # Type :any tests
  def test_any_accepts_mobile
    assert Israeli::Validators::Phone.valid?("0501234567", type: :any)
  end

  def test_any_accepts_landline
    assert Israeli::Validators::Phone.valid?("021234567", type: :any)
  end

  def test_any_accepts_voip
    assert Israeli::Validators::Phone.valid?("0721234567", type: :any)
  end

  def test_any_is_default
    assert Israeli::Validators::Phone.valid?("0501234567")
    assert Israeli::Validators::Phone.valid?("021234567")
  end

  # Format tests
  def test_format_mobile_dashed
    assert_equal "050-123-4567", Israeli::Validators::Phone.format("0501234567")
  end

  def test_format_landline_dashed
    assert_equal "02-123-4567", Israeli::Validators::Phone.format("021234567")
  end

  def test_format_international
    assert_equal "+972-501234567", Israeli::Validators::Phone.format("0501234567", style: :international)
  end

  def test_format_compact
    assert_equal "0501234567", Israeli::Validators::Phone.format("050-123-4567", style: :compact)
  end

  def test_format_returns_nil_for_invalid
    assert_nil Israeli::Validators::Phone.format("123456")
  end

  # Facade method tests
  def test_facade_valid_phone
    assert Israeli.valid_phone?("0501234567")
    assert Israeli.valid_phone?("0501234567", type: :mobile)
    refute Israeli.valid_phone?("123456")
  end

  def test_facade_format_phone
    assert_equal "050-123-4567", Israeli.format_phone("0501234567")
  end
end

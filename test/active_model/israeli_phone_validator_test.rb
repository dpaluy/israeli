# frozen_string_literal: true

require_relative "active_model_test_helper"

class IsraeliPhoneValidatorTest < Minitest::Test
  def test_valid_mobile
    model = PhoneTestModel.new(phone: "0501234567")
    assert model.valid?
  end

  def test_valid_landline
    model = PhoneTestModel.new(phone: "021234567")
    assert model.valid?
  end

  def test_invalid_phone
    model = PhoneTestModel.new(phone: "123456")
    refute model.valid?
  end

  def test_mobile_type_accepts_mobile
    model = PhoneTestModelMobile.new(phone: "0501234567")
    assert model.valid?
  end

  def test_mobile_type_rejects_landline
    model = PhoneTestModelMobile.new(phone: "021234567")
    refute model.valid?
  end

  def test_landline_type_accepts_landline
    model = PhoneTestModelLandline.new(phone: "021234567")
    assert model.valid?
  end

  def test_landline_type_rejects_mobile
    model = PhoneTestModelLandline.new(phone: "0501234567")
    refute model.valid?
  end

  def test_allow_blank
    model = PhoneTestModelAllowBlank.new(phone: "")
    assert model.valid?
  end

  def test_custom_message
    model = PhoneTestModelCustomMessage.new(phone: "invalid")
    refute model.valid?
    assert_includes model.errors[:phone], "must be a valid Israeli phone"
  end
end

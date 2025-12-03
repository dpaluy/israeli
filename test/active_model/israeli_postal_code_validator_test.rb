# frozen_string_literal: true

require_relative "active_model_test_helper"

class IsraeliPostalCodeValidatorTest < Minitest::Test
  def test_valid_postal_code
    model = PostalCodeTestModel.new(postal_code: "2610101")
    assert model.valid?
  end

  def test_valid_with_space
    model = PostalCodeTestModel.new(postal_code: "26101 01")
    assert model.valid?
  end

  def test_invalid_postal_code
    model = PostalCodeTestModel.new(postal_code: "123456")
    refute model.valid?
  end

  def test_allow_blank
    model = PostalCodeTestModelAllowBlank.new(postal_code: "")
    assert model.valid?
  end

  def test_custom_message
    model = PostalCodeTestModelCustomMessage.new(postal_code: "invalid")
    refute model.valid?
    assert_includes model.errors[:postal_code], "must be a valid Israeli postal code"
  end
end

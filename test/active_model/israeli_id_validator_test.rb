# frozen_string_literal: true

require_relative "active_model_test_helper"

class IsraeliIdValidatorTest < Minitest::Test
  def test_valid_id
    model = IdTestModel.new(id_number: "123456782")
    assert model.valid?
  end

  def test_invalid_id
    model = IdTestModel.new(id_number: "123456789")
    refute model.valid?
    assert_includes model.errors[:id_number], "is invalid"
  end

  def test_nil_fails_by_default
    model = IdTestModel.new(id_number: nil)
    refute model.valid?
  end

  def test_allow_nil
    model = IdTestModelAllowNil.new(id_number: nil)
    assert model.valid?
  end

  def test_allow_blank
    model = IdTestModelAllowBlank.new(id_number: "")
    assert model.valid?
  end

  def test_custom_message
    model = IdTestModelCustomMessage.new(id_number: "invalid")
    refute model.valid?
    assert_includes model.errors[:id_number], "is not a valid Mispar Zehut"
  end
end

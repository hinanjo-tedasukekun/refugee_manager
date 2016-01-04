require 'test_helper'

class BarcodeTest < Minitest::Test
  def setup
    @shelter_ids = [19, 19, 123]
    @refugee_ids = [1, 1234, 9876]
    @codes = %w(01900019 01912340 12398768)
    @barcodes = @codes.map { |code| Barcode.new(code: code) }
  end

  def test_code
    @codes.zip(@barcodes).each do |code, barcode|
      assert_equal code, barcode.code
    end
  end

  def test_from_id
    @shelter_ids.
      zip(@refugee_ids, @codes).
      each do |shelter_id, refugee_id, code|
        barcode = Barcode.from_id(shelter_id, refugee_id)
        assert_equal barcode.code, code
      end
  end

  def test_from_id_raises_argument_error
    assert_raises ArgumentError, '避難所番号が負' do
      Barcode.from_id(-1, 1234)
    end

    assert_raises ArgumentError, '避難所番号が大きすぎる' do
      Barcode.from_id(1000, 1234)
    end

    assert_raises ArgumentError, '避難者番号が負' do
      Barcode.from_id(123, -1)
    end

    assert_raises ArgumentError, '避難者番号が大きすぎる' do
      Barcode.from_id(123, 10000)
    end
  end

  def test_equality
    @barcodes.each do |barcode|
      other_barcode = Barcode.new(code: barcode.code)
      assert_operator other_barcode, :==, barcode
    end
  end

  def test_shelter_id
    @shelter_ids.zip(@barcodes).each do |shelter_id, barcode|
      assert_equal shelter_id, barcode.shelter_id
    end
  end

  def test_refugee_id
    @refugee_ids.zip(@barcodes).each do |refugee_id, barcode|
      assert_equal refugee_id, barcode.refugee_id
    end
  end

  def test_valid_bar_codes_should_be_judged_valid
    @barcodes.each do |barcode|
      assert barcode.valid?
    end
  end

  # 数字以外のコードは無効
  def test_non_numeric_codes_should_be_judged_invalid
    non_numeric_codes = [
      'ABC12345',
      '123 4567',
      '432-8053'
    ]

    non_numeric_codes.each do |code|
      refute Barcode.new(code: code).valid?, "#{code.inspect} は無効"
    end
  end

  # 長さが合っていないコードは無効
  def test_shorter_or_longer_codes_should_be_judged_invalid
    shorter_or_longer_codes = [
      '0190001',
      '019123456'
    ]

    shorter_or_longer_codes.each do |code|
      refute Barcode.new(code: code).valid?, "#{code.inspect} は無効"
    end
  end

  # チェックディジットが合っていないコードは無効
  def test_codes_including_bad_check_digit_should_be_judged_invalid
    codes_including_bad_check_digit = [
      '01900011',
      '01912345',
      '12398760'
    ]

    codes_including_bad_check_digit.each do |code|
      refute Barcode.new(code: code).valid?, "#{code.inspect} は無効"
    end
  end
end

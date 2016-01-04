require 'minitest/autorun'
require_relative '../../../lib/refugee_manager/bar_code'

# バーコードクラスのテスト
class TestBarCode < Minitest::Test
  def setup
    @bar_code_1 = RefugeeManager::BarCode.new('01900019')
    @bar_code_2 = RefugeeManager::BarCode.new('01912340')
    @bar_code_3 = RefugeeManager::BarCode.new('12398768')
  end

  def test_code
    assert_equal('01900019',
                 @bar_code_1.code,
                 'バーコード 1 のコードが正しい')
    assert_equal('01912340',
                 @bar_code_2.code,
                 'バーコード 2 のコードが正しい')
    assert_equal('12398768',
                 @bar_code_3.code,
                 'バーコード 3 のコードが正しい')
  end

  def test_shelter_id
    assert_equal(19,
                 @bar_code_1.shelter_id,
                 'バーコード 1 の避難所番号が正しい')
    assert_equal(19,
                 @bar_code_2.shelter_id,
                 'バーコード 2 の避難所番号が正しい')
    assert_equal(123,
                 @bar_code_3.shelter_id,
                 'バーコード 3 の避難所番号が正しい')
  end

  def test_refugee_id
    assert_equal(1,
                 @bar_code_1.refugee_id,
                 'バーコード 1 の避難者番号が正しい')
    assert_equal(1234,
                 @bar_code_2.refugee_id,
                 'バーコード 2 の避難者番号が正しい')
    assert_equal(9876,
                 @bar_code_3.refugee_id,
                 'バーコード 3 の避難者番号が正しい')
  end

  def test_valid_bar_codes_should_be_judged_valid
    assert(@bar_code_1.valid?, 'バーコード 1 が有効と判断される')
    assert(@bar_code_2.valid?, 'バーコード 2 が有効と判断される')
    assert(@bar_code_3.valid?, 'バーコード 3 が有効と判断される')
  end

  # 数字以外のコードは無効
  def test_non_numeric_codes_should_be_judged_invalid
    non_numeric_codes = [
      'ABC12345',
      '123 4567',
      '432-8053'
    ]

    non_numeric_codes.each { |code| invalid_code_assertions(code) }
  end

  # 長さが合っていないコードは無効
  def test_shorter_or_longer_codes_should_be_judged_invalid
    shorter_or_longer_codes = [
      '0190001',
      '019123456'
    ]

    shorter_or_longer_codes.each { |code| invalid_code_assertions(code) }
  end

  def test_codes_including_bad_check_digit_should_be_judged_invalid
    codes_including_bad_check_digit = [
      '01900011',
      '01912345',
      '12398760'
    ]

    codes_including_bad_check_digit.each do |code|
      invalid_code_assertions(code)
    end
  end

  private

  def invalid_code_assertions(code)
    bar_code = RefugeeManager::BarCode.new(code)
    assert(!bar_code.valid?, "#{code}: 無効と判断される")
    assert_equal(nil, bar_code.shelter_id)
    assert_equal(nil, bar_code.refugee_id)
  end
end

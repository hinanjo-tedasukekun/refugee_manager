require 'test_helper'

class FamilyTest < ActiveSupport::TestCase
  def setup
    @family = families(:pc_hamamatsu)
  end

  test 'デフォルト値が正しい' do
    default = families(:default)

    assert_equal 1, default.num_of_members, '家族の人数'
    assert_equal 'unspecified', default.at_home, '在宅避難'
    assert_equal '',  default.address, '住所'
    assert_equal '',  default.postal_code, '郵便番号'
  end

  test '有効である' do
    assert @family.valid?
  end

  test '家族の人数は必須である' do
    @family.num_of_members = nil
    assert_not @family.valid?
  end

  test '家族の人数は 0 より大きい' do
    @family.num_of_members = 0
    assert_not @family.valid?
  end

  test '家族の人数は整数である' do
    @family.num_of_members = 1.1
    assert_not @family.valid?
  end

  test '在宅：未指定' do
    @family.at_home = :unspecified
    assert @family.valid?
  end

  test '在宅：在宅避難' do
    @family.at_home = :at_home
    assert @family.valid?
  end

  test '在宅：避難所で避難する' do
    @family.at_home = :in_refuge
    assert @family.valid?
  end

  test '在宅：その他（エラー）' do
    assert_raises(ArgumentError) do
      @family.at_home = :etc
    end
  end

  test '住所は空でもよい' do
    @family.address = ''
    assert @family.valid?
  end

  test '郵便番号は空でもよい' do
    @family.postal_code = ''
    assert @family.valid?
  end

  test '郵便番号は空白文字ではない' do
    @family.postal_code = '   '
    assert_not @family.valid?
  end

  test '郵便番号は数字である' do
    @family.postal_code = 'abc1234'
    assert_not @family.valid?
  end

  test '郵便番号は 7 桁の数字である' do
    # 浜松市役所の郵便番号から最後の '2' を取った
    @family.postal_code = '430865'
    assert_not @family.valid?
  end
end

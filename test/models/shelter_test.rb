require 'test_helper'

class ShelterTest < ActiveSupport::TestCase
  def setup
    @shelter = create(:shelter)
  end

  test 'デフォルト値が正しい' do
    default = Shelter.new

    assert_equal 1, default.num, '避難所番号'
    assert_equal 'ポリテクカレッジ浜松', default.name, '避難所名'
    assert_equal '',  default.address, '住所'
    assert_equal '',  default.postal_code, '郵便番号'
  end

  test '有効である' do
    assert @shelter.valid?
  end

  test '避難所番号は必須である' do
    @shelter.num = nil
    refute @shelter.valid?
  end

  test '避難所番号は 0 より大きい' do
    @shelter.num = 0
    refute @shelter.valid?
  end

  test '避難所番号は 1000 より大きい' do
    @shelter.num = 1000
    refute @shelter.valid?
  end

  test '避難所番号は整数である' do
    @shelter.num = 1.1
    refute @shelter.valid?
  end

  test '避難所名は空であってはならない' do
    @shelter.name = ''
    refute @shelter.valid?
  end

  test '避難所名は空白だけであってはならない' do
    @shelter.name = ' ' * 10
    refute @shelter.valid?
  end

  test '住所は空でもよい' do
    @shelter.address = ''
    assert @shelter.valid?
  end

  test '郵便番号が有効と判断される' do
    @shelter.postal_code = '4308652'
    assert @shelter.valid?
  end

  test '郵便番号は空でもよい' do
    @shelter.postal_code = ''
    assert @shelter.valid?
  end

  test '郵便番号は空白文字ではない' do
    @shelter.postal_code = '   '
    refute @shelter.valid?
  end

  test '郵便番号は数字である' do
    @shelter.postal_code = 'abc1234'
    refute @shelter.valid?
  end

  test '郵便番号は 7 桁の数字である' do
    # 浜松市役所の郵便番号から最後の '2' を取った
    @shelter.postal_code = '430865'
    refute @shelter.valid?
  end
end

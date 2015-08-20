require 'test_helper'

class RefugeeTest < ActiveSupport::TestCase
  def setup
    @foo = refugees(:foo)
    @bar = refugees(:bar)
  end

  test 'デフォルト値が正しい' do
    default = refugees(:default)

    assert_equal true, default.presence, '在室'
    assert_equal '', default.name, '名前'
    assert_equal '', default.furigana, 'ふりがな'
    assert_equal nil, default.age, '年齢'
  end

  test '有効である' do
    assert @foo.valid?
    assert @bar.valid?
  end

  test '名前は空でもよい' do
    @foo.name = ''
    assert @foo.valid?
  end

  test '名前は 64 文字以内である' do
    @foo.name = 'あ' * 65
    assert_not @foo.valid?
  end

  test 'ふりがなは空でもよい' do
    @foo.furigana = ''
    assert @foo.valid?
  end

  test 'ふりがなは 64 文字以内である' do
    @foo.furigana = 'あ' * 65
    assert_not @foo.valid?
  end

  test '性別：未指定' do
    @foo.gender = :unspecified
    assert @foo.valid?
  end

  test '性別：男性' do
    @foo.gender = :male
    assert @foo.valid?
  end

  test '性別：女性' do
    @foo.gender = :female
    assert @foo.valid?
  end

  test '性別：その他（エラー）' do
    assert_raises(ArgumentError) do
      @foo.gender = :etc
    end
  end

  test '年齢は空でもよい' do
    @foo.age = nil
    assert @foo.valid?
  end

  test '年齢は数である' do
    @foo.age = 'abc'
    assert_not @foo.valid?
  end

  test '年齢は整数である' do
    @foo.age = 0.5
    assert_not @foo.valid?
  end

  test '年齢は 0 以上である' do
    @foo.age = -1
    assert_not @foo.valid?
  end
end

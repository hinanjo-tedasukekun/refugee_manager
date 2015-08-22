require 'test_helper'

class RefugeeTest < ActiveSupport::TestCase
  def setup
    @refugee = create(:refugee)
  end

  test 'デフォルト値が正しい' do
    default = Refugee.new

    assert_equal true, default.presence, '在室'
    assert_equal '', default.name, '名前'
    assert_equal '', default.furigana, 'ふりがな'
    assert_equal nil, default.age, '年齢'
  end

  test '有効である' do
    assert @refugee.valid?
  end

  test '名前は空でもよい' do
    @refugee.name = ''
    assert @refugee.valid?
  end

  test '名前は 64 文字以内である' do
    @refugee.name = 'あ' * 65
    assert_not @refugee.valid?
  end

  test 'ふりがなは空でもよい' do
    @refugee.furigana = ''
    assert @refugee.valid?
  end

  test 'ふりがなは 64 文字以内である' do
    @refugee.furigana = 'あ' * 65
    assert_not @refugee.valid?
  end

  test '性別：未指定' do
    @refugee.gender = :unspecified
    assert @refugee.valid?
  end

  test '性別：男性' do
    @refugee.gender = :male
    assert @refugee.valid?
  end

  test '性別：女性' do
    @refugee.gender = :female
    assert @refugee.valid?
  end

  test '性別：その他（エラー）' do
    assert_raises(ArgumentError) do
      @refugee.gender = :etc
    end
  end

  test '年齢は空でもよい' do
    @refugee.age = nil
    assert @refugee.valid?
  end

  test '年齢は数である' do
    @refugee.age = 'abc'
    assert_not @refugee.valid?
  end

  test '年齢は整数である' do
    @refugee.age = 0.5
    assert_not @refugee.valid?
  end

  test '年齢は 0 以上である' do
    @refugee.age = -1
    assert_not @refugee.valid?
  end
end

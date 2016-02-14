require 'test_helper'

class RefugeeTest < ActiveSupport::TestCase
  def setup
    @shelter = create(:shelter)
    @refugee = create(:refugee)
    @refugee2 = create(:refugee2)
    @allergen = create(:allergen)
    @leader = create(:family_leader)
  end

  test 'デフォルト値が正しい' do
    default = Refugee.new

    assert_equal true, default.presence, '在室'
    assert_equal '', default.name, '名前'
    assert_equal '', default.furigana, 'ふりがな'
    assert_equal nil, default.age, '年齢'
    assert_equal false, default.password_protected, 'パスワード保護'
    assert_equal '', default.other_allergens
  end

  test '有効である' do
    assert @refugee.valid?
  end

  test '世帯は必須である' do
    @refugee.family = nil
    refute @refugee.valid?
  end

  test '名前は空でもよい' do
    @refugee.name = ''
    assert @refugee.valid?
  end

  test '名前は 64 文字以内である' do
    @refugee.name = 'あ' * 65
    refute @refugee.valid?
  end

  test 'ふりがなは空でもよい' do
    @refugee.furigana = ''
    assert @refugee.valid?
  end

  test 'ふりがなは 64 文字以内である' do
    @refugee.furigana = 'あ' * 65
    refute @refugee.valid?
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
    refute @refugee.valid?
  end

  test '年齢は整数である' do
    @refugee.age = 0.5
    refute @refugee.valid?
  end

  test '年齢は 0 以上である' do
    @refugee.age = -1
    refute @refugee.valid?
  end

  test 'パスワード不使用時はパスワードが空である' do
    @refugee.password_protected = false

    @refugee.password = @refugee.password_confirmation = nil
    assert @refugee.valid?(:change_password), 'password == nil => valid'

    @refugee.password = @refugee.password_confirmation = '12345678'
    refute @refugee.valid?(:change_password), 'password != nil => invalid'
  end

  test 'パスワード使用時はパスワードが必須である' do
    @refugee.password_protected = true
    @refugee.password = @refugee.password_confirmation = nil
    refute @refugee.valid?(:change_password)
  end

  test 'パスワードと確認欄が異なってはならない' do
    @refugee.password_protected = true
    @refugee.password = '12345678'
    @refugee.password_confirmation = '123456789'
    refute @refugee.valid?(:change_password)
  end

  test 'パスワードは空白以外の文字を含まなければならない' do
    @refugee.password_protected = true
    @refugee.password = @refugee.password_confirmation = ' ' * 4
    refute @refugee.valid?(:change_password)
  end

  test 'パスワードは 4 文字以上である' do
    @refugee.password_protected = true
    @refugee.password = @refugee.password_confirmation = 'a' * 3
    refute @refugee.valid?(:change_password)
  end

  test '正しいバーコードが得られる' do
    num = Barcode.from_id(@shelter.num, @refugee.id).code
    assert_equal num, @refugee.barcode.code
  end

  test 'その他アレルゲンは空でもよい' do
    @refugee.other_allergens = ''
    assert @refugee.valid?
  end

  test '世帯の代表者であると判断される' do
    assert @refugee.leader?
  end

  test '世帯の代表者ではないと判断される' do
    refute @refugee2.leader?
  end

  test '基本情報が設定されていないと判断される' do
    @refugee.name = @refugee.furigana = ''
    @refugee.gender = 'unspecified'
    @refugee.age = nil
    refute @refugee.set_basic_info?
  end

  test '基本情報が設定されていると判断される（名前）' do
    @refugee.name = 'あ'
    @refugee.furigana = ''
    @refugee.gender = 'unspecified'
    @refugee.age = nil
    assert @refugee.set_basic_info?
  end

  test '基本情報が設定されていると判断される（ふりがな）' do
    @refugee.name = ''
    @refugee.furigana = 'あ'
    @refugee.gender = 'unspecified'
    @refugee.age = nil
    assert @refugee.set_basic_info?
  end

  test '基本情報が設定されていると判断される（性別）' do
    @refugee.name = ''
    @refugee.furigana = ''
    @refugee.gender = 'male'
    @refugee.age = nil
    assert @refugee.set_basic_info?
  end

  test '基本情報が設定されていると判断される（年齢）' do
    @refugee.name = ''
    @refugee.furigana = ''
    @refugee.gender = 'unspecified'
    @refugee.age = 0
    assert @refugee.set_basic_info?
  end

  test 'アレルギーがないと判断される' do
    @refugee.allergens = []
    @refugee.other_allergens = ''
    refute @refugee.have_allergies?
  end

  test 'アレルギーがあると判断される（アレルゲン）' do
    @refugee.allergens = [@allergen]
    @refugee.other_allergens = ''
    assert @refugee.have_allergies?
  end

  test 'アレルギーがあると判断される（その他のアレルゲン）' do
    @refugee.allergens = []
    @refugee.other_allergens = 'あ'
    assert @refugee.have_allergies?
  end
end

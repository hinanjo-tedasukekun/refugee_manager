require 'test_helper'

class AllergenTest < ActiveSupport::TestCase
  def setup
    @allergen = create(:allergen)
  end

  test '名前に空白以外の文字が含まれなければならない' do
    @allergen.name = ' ' * 10
    assert @allergen.invalid?
  end

  test '名前の文字数制限' do
    @allergen.name = 'a' * 32
    assert @allergen.valid?, '最大文字数の場合は有効'

    @allergen.name = 'a' * 33
    assert @allergen.invalid?, '文字数超過は無効'
  end
end

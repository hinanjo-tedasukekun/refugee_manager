require 'test_helper'

class SupplyTest < ActiveSupport::TestCase
  def setup
    @supply = create(:supply)
  end

  test '名前に空白以外の文字が含まれなければならない' do
    @supply.name = ' ' * 10
    assert @supply.invalid?
  end

  test '名前の文字数制限' do
    @supply.name = 'a' * 32
    assert @supply.valid?, '最大文字数の場合は有効'

    @supply.name = 'a' * 33
    assert @supply.invalid?, '文字数超過は無効'
  end
end

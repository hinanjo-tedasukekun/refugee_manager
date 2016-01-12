require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  def setup
    @skill = create(:skill)
  end

  test '名前に空白以外の文字が含まれなければならない' do
    @skill.name = ' ' * 10
    assert @skill.invalid?
  end

  test '名前の文字数制限' do
    @skill.name = 'a' * 32
    assert @skill.valid?, '最大文字数の場合は有効'

    @skill.name = 'a' * 33
    assert @skill.invalid?, '文字数超過は無効'
  end
end

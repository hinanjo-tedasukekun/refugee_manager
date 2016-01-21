require 'test_helper'

class NoticeTest < ActiveSupport::TestCase
  def setup
    @notice = create(:notice)
  end

  test 'タイトルが必要' do
    @notice.title = ' ' * 10
    assert @notice.invalid?
  end

  test '内容が必要' do
    @notice.content = ' ' * 10
    assert @notice.invalid?
  end
end

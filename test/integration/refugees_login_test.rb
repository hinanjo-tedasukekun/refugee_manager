require 'test_helper'

class RefugeesLoginTest < ActionDispatch::IntegrationTest
  test '無効な番号でログインする' do
    host! 'hinan.jp'
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: '0' }
    assert_template 'refugee_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

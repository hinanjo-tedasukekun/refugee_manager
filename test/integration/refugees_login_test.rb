require 'test_helper'

class RefugeesLoginTest < ActionDispatch::IntegrationTest
  NORMAL_HOST = 'hinan.jp'

  test '無効な番号でログインする' do
    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: '0' }
    assert_template 'refugee_sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test '有効な番号でログインする' do
    leader = FactoryGirl.create(:leader)
    refugee = leader.refugee
    refugee_num = RefugeeManager::BarCode.from_id(19, refugee.id).code

    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: refugee_num }
    assert_redirected_to profile_path
  end
end

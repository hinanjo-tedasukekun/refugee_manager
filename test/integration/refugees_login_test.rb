require 'test_helper'

class RefugeesLoginTest < ActionDispatch::IntegrationTest
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

  test '登録されている番号でログインする' do
    leader = FactoryGirl.create(:leader)
    refugee = leader.refugee
    refugee_num = RefugeeManager::BarCode.from_id(19, refugee.id).code

    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'
    post login_path, session: { refugee_num: refugee_num }
    assert_redirected_to profile_path
  end

  test '未登録の番号でログインする' do
    host! NORMAL_HOST
    get login_path
    assert_template 'refugee_sessions/new'

    num = RefugeeManager::BarCode.
      from_id(ApplicationHelper::REFUGE_ID, 9999).
      code
    post login_path, session: { refugee_num: num }
    assert_redirected_to controller: 'profile', action: 'new', num: num
    follow_redirect!
    assert_select '#refugee_num', num
  end
end
